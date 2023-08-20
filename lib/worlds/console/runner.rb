require 'pastel'
require_relative 'helper'
require_relative 'updater'

module Worlds
  module Console
    # A container for the input loop, which is needed because input is read in
    # a non-blocking way, i.e. input is read while new output is displayed.
    class Runner
      PASTEL = Pastel.new
      CURSOR = '█'
      BACKSPACE = "\x7F"
      CTRL_BACKSPACE = "\x17" # or Cmd+Backspace on MacOS
      INTERRUPT = "\x03" # Ctrl+C

      # Loops continuously, reading input and allowing Worlds to update and output.
      def self.io_loop
        loop do
          # We need our own input buffer here because the terminal input buffer is
          # disabled due to Helper::io_mode_raw!
          @input_buffer ||= ''

          new_input = Helper.read_nonblock

          if new_input
            return if new_input.include?(INTERRUPT)

            # Handle Enter.
            new_input_has_newline = new_input.include?("\n") || new_input.include?("\r")
            new_input = new_input.split(/[\n\r]/).first if new_input_has_newline

            # Add new input to buffer (or add nothing, if no new input).
            @input_buffer << (new_input || '')

            # Handle deletion: Ctrl + Backspace (line), or Backspace (character).
            # In either case, re-print the input buffer with spaces at the end
            # to cover over the deleted characters.
            if @input_buffer.include?(CTRL_BACKSPACE)
              print "#{CURSOR}#{' ' * @input_buffer.length}\r"
              @input_buffer = ''
            else
              backspace_count = @input_buffer.count(BACKSPACE)

              while @input_buffer.length > 0 && @input_buffer.include?(BACKSPACE)
                @input_buffer.sub!(/[^#{BACKSPACE}]#{BACKSPACE}/, '')
                @input_buffer = '' if @input_buffer.chars.uniq == [BACKSPACE]
              end

              print "#{@input_buffer}#{CURSOR}#{' ' * backspace_count}\r"
            end

            # Echo input. The \r is to make the line replacable by new output,
            # while the input line will re-appear below the new output; in effect,
            # to allow output above the input line.
            print "#{@input_buffer}#{CURSOR}\r"
          end

          # Empty the input buffer if Enter was pressed.
          if new_input_has_newline
            input_line = @input_buffer.strip
            @input_buffer = ''
          end

          # If a line was just inputted, set up an input hash as either a number
          # selection (if a selection menu was just shown) or else a new command.
          if input_line
            if @select_for && input_line.match?(/\A\d+\z/)
              input = { type: :select, command: @select_for, selection: input_line.to_i }
              @select_for = nil
            else
              input = { type: :command, command: input_line }
            end
          end

          # Allow Worlds to loop, and print outputs if any.
          if outputs = Worlds::Updater.tick(input)
            outputs.each do |output|
              case output[:type]
              when :exit
                return
              when :select # selection menu
                Helper.puts PASTEL.white(output[:heading])
                output[:options].each.with_index do |option, i|
                  Helper.puts PASTEL.blue("#{i + 1}. ") + PASTEL.white(option)
                end

                @select_for = input_line
              else # informational
                Helper.puts PASTEL.send(output[:color], output[:content])
              end
            end
          end

          # Reset input, to remain empty until next time Enter is pressed.
          input_line = nil && input = nil if input_line
        end
      end
    end
  end
end
