require 'debug'
require 'pastel'

class WorldsGemStub
  UPDATES_PER_SECOND = 1

  def self.loop(input = nil)
    @time_start ||= Process.clock_gettime(Process::CLOCK_MONOTONIC)

    time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    time_elapsed = time_now - @time_start

    return process_input(input) if input

    if time_elapsed >= (1.0 / UPDATES_PER_SECOND)
      @time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      return update
    end
  end

  def self.process_input(input)
    outputs = []

    outputs << { color: :white, content: "You said: #{input}" }
    outputs << { special: :exit } if input == 'exit'

    outputs
  end

  def self.update
    outputs = []

    seconds = 1.0 / UPDATES_PER_SECOND.round(2)
    outputs << { color: :blue, content: "#{seconds} seconds have passed!" }

    outputs
  end
end

PASTEL = Pastel.new
print "\033[?25l" # Hide cursor, from https://stackoverflow.com/a/50152099
`stty raw -echo`

$inputting = ''
input_line = nil

class IO
  # Based on https://stackoverflow.com/a/9900628
  def read_all_nonblock
    line = ""

    while char = self.read_nonblock(1, exception: false)
      return line if char == :wait_readable
      line << char
    end
  end
end

def puts_stty(str)
  terminal_width = `tput cols`.to_i # From https://gist.github.com/KINGSABRI/4687864
  padding = terminal_width - str.length
  padding = 0 if padding < 0

  `stty -raw echo`
  puts "#{str}#{' ' * padding}"
  `stty raw -echo`
end

def game_loop
  loop do
    # TODO: make this work on Windows: https://stackoverflow.com/a/22659929
    new_input = STDIN.read_all_nonblock

    if new_input
      new_input_has_newline = new_input.include?("\n") || new_input.include?("\r")
      new_input = new_input.split(/[\n\r]/).first if new_input_has_newline

      $inputting << (new_input || '')

      while $inputting.length > 0 && $inputting.include?("\x7F")
        $inputting.sub!(/.\x7F/, '')
        $inputting = '' if $inputting.chars.uniq == ["\x7F"]
      end

      print "#{$inputting}█\r"
    end

    if new_input_has_newline
      input_line = $inputting
      $inputting = ''
    end

    if outputs = WorldsGemStub.loop(input_line)
      outputs.each do |output|
        return if output[:special] == :exit

        puts_stty PASTEL.send(output[:color], output[:content])
      end
    end

    input_line = nil if input_line
  end
end

begin
  game_loop

  puts_stty "Oh, I quit."
ensure
  `stty -raw echo`
  print "\033[?25h" # Show cursor
end
