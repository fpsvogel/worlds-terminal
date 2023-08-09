require 'time'

loop do
  time = Time.now.to_s + "\r"
  print time
  $stdout.flush
  sleep 1
end
