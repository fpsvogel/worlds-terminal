require 'debug'
require 'remedy'
include Remedy

abs_time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
time_start = abs_time_start
ms_counter = 0
reader = Interaction.new
inputting = ''
output = Content.new

reader.loop do |key|
  if key == "\n"
    output << "You said: #{inputting}"
    inputting = ''
  else
    inputting << key.to_s
  end

  time_now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  time_elapsed = time_now - time_start

  if time_elapsed >= 0.01
    ms_counter += 1
    time_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    screen = Viewport.new
    prompt = Partial.new
    prompt << "> #{inputting}█"
    output << 'no content' if output.lines.empty?
    screen.draw output, Size.new(0,0), prompt
  end

  if ms_counter == 100
    debugger
    output << "One second has passed!"
    ms_counter = 0
    output << "Absolute time elapsed: #{time_now - abs_time_start}"
  end
end

puts "Oh, I quit."

# include Remedy
# title = Partial.new
# title << "Someone Said These Were Good"

# jokes = Content.new
# jokes << %q{1. A woman gets on a bus with her baby. The bus driver says: 'Ugh, that's the ugliest baby I've ever seen!' The woman walks to the rear of the bus and sits down, fuming. She says to a man next to her: 'The driver just insulted me!' The man says: 'You go up there and tell him off. Go on, I'll hold your monkey for you.'}
# jokes << %q{2. I went to the zoo the other day, there was only one dog in it, it was a shitzu.}

# disclaimer = Partial.new
# disclaimer << "According to a survey they were funny. I didn't make them."

# screen = Viewport.new
# screen.draw jokes, Size.new(0,0), title, disclaimer
