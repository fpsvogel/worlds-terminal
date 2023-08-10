require 'debug'
require 'pastel'
require_relative 'worlds_gem_stub'

PASTEL = Pastel.new
BACKSPACE = "\x7F"
print "\033[?25l" # Hide cursor, from https://stackoverflow.com/a/50152099
`stty raw -echo` # To allow output above input line, off input buffer and echo.
@input_buffer = '' # Needed here now that the console input buffer is off.

class IO
  # To allow output above input line.
  # Based on https://stackoverflow.com/a/9900628
  def read_all_nonblock
    line = ""

    while char = self.read_nonblock(1, exception: false)
      return line if char == :wait_readable
      line << char
    end
  end
end

# To allow output above input line.
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

      @input_buffer << (new_input || '')

      while @input_buffer.length > 0 && @input_buffer.include?(BACKSPACE)
        @input_buffer.sub!(/.#{BACKSPACE}/, '')
        @input_buffer = '' if @input_buffer.chars.uniq == [BACKSPACE]
      end

      print "#{@input_buffer}█\r"
    end

    if new_input_has_newline
      input_line = @input_buffer
      @input_buffer = ''
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
