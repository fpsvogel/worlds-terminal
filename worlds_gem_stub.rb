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
