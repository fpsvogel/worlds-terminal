module Worlds
  module Terminal
    # Utility methods for allowing output above the input line in the terminal.
    class Helper
      # To allow output above the input line, disables input buffering.
      def self.io_mode_raw! = `stty raw`
      def self.io_mode_normal! = `stty -raw`

      # From https://stackoverflow.com/a/50152099
      # If the cursor weren't hidden, it would appear at the beginning of the line
      # due to ::io_mode_raw!
      def self.hide_cursor! = print "\033[?25l"
      def self.show_cursor! = print "\033[?25h"

      # Reads newly inputted characters in a way that doesn't block output,
      # to allow output above the input line. Based on https://stackoverflow.com/a/9900628
      # @return [String] all inputted characters.
      def self.read_nonblock
        line = ''

        while char = STDIN.read_nonblock(1, exception: false)
          return line if char == :wait_readable
          line << char
        end
      end

      # To allow output above the input line, wraps `puts` in a change to the
      # terminal mode. Also right-pads the output with spaces to prevent the input
      # from "bleeding over" into output wherever an output line is shorter than a
      # line being inputted.
      # @parmam str [String] The string to print.
      def self.puts(str)
        # From https://gist.github.com/KINGSABRI/4687864
        terminal_width = `tput cols`.to_i

        io_mode_normal!
        Kernel.puts str.ljust(terminal_width, ' ')
        io_mode_raw!
      end
    end
  end
end
