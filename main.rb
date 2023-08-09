require 'debug'
require 'colorize'

print "\033[?25l" # Hide cursor, from https://stackoverflow.com/a/50152099

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

  puts "#{str}#{' ' * padding}"
  print "#{$inputting}█\r"
end

begin
  loop do
    # TODO: make this work on Windows: https://stackoverflow.com/a/22659929
    `stty raw -echo`
    new_input = STDIN.read_all_nonblock
    `stty -raw echo`

    if new_input
      $inputting << new_input

      while $inputting.length > 0 && $inputting.include?("\x7F")
        $inputting.sub!(/.\x7F/, '')
        $inputting = '' if $inputting.chars.uniq == ["\x7F"]
      end

      print "#{$inputting}█\r"
    end

    if $inputting.chars.include?("\n") || $inputting.chars.include?("\r")
      input_line = $inputting.split(/[\n\r]/).first
      $inputting = ''
    end

    if input_line
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
  print "\033[?25h" # Show cursor
end
