require 'debug'
require 'colorize'

print "\033[?25l" # Hide cursor

time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

$inputting = ''
input_line = nil

class IO
  def read_all_nonblock
    line = ""

    while char = self.read_nonblock(1, exception: false)
      return line if char == :wait_readable
      line << char
    end
  end
end

def output(str)
  terminal_width = `tput cols`.to_i
  padding = terminal_width - str.length
  padding = 0 if padding < 0

  puts "#{str}#{' ' * padding}"
  print "#{$inputting}█\r"
end

begin
  loop do
    `stty raw -echo`
    new_input = STDIN.read_all_nonblock
    `stty -raw echo`

    if new_input
      $inputting << new_input
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
