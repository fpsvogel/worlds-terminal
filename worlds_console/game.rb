require 'pastel'
require_relative 'io'
require_relative 'worlds_gem_stub'

module WorldsConsole
  class Game
    PASTEL = Pastel.new
    BACKSPACE = "\x7F"
    CTRL_BACKSPACE = "\x17" # or Cmd+Backspace on MacOS
    INTERRUPT = "\x03" # Ctrl+C

    def self.input_loop
      loop do
        # An internal input buffer is needed because the console input buffer is off
        # due to WorldsConsole::Helper::output_mode_special!
        @input_buffer ||= ''

        # STDIN inherits from IO, so here the monkey patch in IO is used.
        # TODO: make this work on Windows: https://stackoverflow.com/a/22659929
        new_input = STDIN.read_all_nonblock

        if new_input
          return if new_input.include?(INTERRUPT)

          # Handle Enter.
          new_input_has_newline = new_input.include?("\n") || new_input.include?("\r")
          new_input = new_input.split(/[\n\r]/).first if new_input_has_newline

          # Add new input to buffer (or add nothing, if no new input or if Enter.)
          @input_buffer << (new_input || '')

          # Handle Backspace.
          if @input_buffer.include?(CTRL_BACKSPACE)
            @input_buffer = ''
          else
            while @input_buffer.length > 0 && @input_buffer.include?(BACKSPACE)
              @input_buffer.sub!(/.#{BACKSPACE}/, '')
              @input_buffer = '' if @input_buffer.chars.uniq == [BACKSPACE]
            end
          end

          # Echo input. The \r is to make the line replacable by new output,
          # while the input will be echoed below the new output; in effect,
          # to allow output above the input line.
          print "#{@input_buffer}█\r"
        end

        # Empty the input buffer if Enter was pressed.
        if new_input_has_newline
          input_line = @input_buffer
          @input_buffer = ''
        end

        # Allow Worlds to loop, and print outputs if any.
        if outputs = WorldsGemStub.loop(input_line)
          outputs.each do |output|
            return if output[:special] == :exit

            Helper.puts_special PASTEL.send(output[:color], output[:content])
          end
        end

        # Reset input_line, to remain empty until next time Enter is pressed.
        input_line = nil if input_line
      end
    end
  end
end
