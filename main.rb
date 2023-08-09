require 'debug'

time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

class IO
  def readline_nonblock
    line = ""

    while char = self.read_nonblock(1, exception: false)
      return nil if char == :wait_readable
      return line if char == "\n"
      line << char
    end
  end
end

loop do
  if line = STDIN.readline_nonblock
    puts "I found an #{line}"
    break if line == 'exit'
  end

  time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  time_elapsed = time_now - time_start
  if time_elapsed >= 1
    puts "One second has passed!"
    time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end

puts "Oh, I quit."
