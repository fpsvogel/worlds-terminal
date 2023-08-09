require 'debug'
require 'tty-reader'

reader = TTY::Reader.new
time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

loop do
  line = reader.read_line(nonblock: true).chomp

  break if line == 'exit'

  time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  time_elapsed = time_now - time_start
  if time_elapsed >= 1
    puts "One second has passed!"
    time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end

puts "Oh, I quit."
