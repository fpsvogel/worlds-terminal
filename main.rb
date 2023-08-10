require 'debug'
require 'colorize'

print "\033[?25l" # Hide cursor, from https://stackoverflow.com/a/50152099
`stty raw -echo`

time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

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

def output(str)
  terminal_width = `tput cols`.to_i # From https://gist.github.com/KINGSABRI/4687864
  padding = terminal_width - str.length
  padding = 0 if padding < 0

  `stty -raw echo`
  puts "#{str}#{' ' * padding}"
  `stty raw -echo`
end

begin
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

      output "You said: #{input_line}"
      break if input_line == 'exit'
      input_line = nil
    end

    time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    time_elapsed = time_now - time_start
    if time_elapsed >= 1
      output "One second has passed!".blue
      time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end

  output "Oh, I quit."
ensure
  `stty -raw echo`
  print "\033[?25h" # Show cursor
end
