class ConsoleHelper
  # From https://stackoverflow.com/a/50152099
  def self.hide_cursor! = print "\033[?25l"
  def self.show_cursor! = print "\033[?25h"

  # To allow output above the input line, disables input buffering and echo.
  def self.output_mode_special! = `stty raw -echo`
  def self.output_mode_normal! = `stty -raw echo`

  # To allow output above the input line, wraps `puts` in a change to the output
  # mode. Also right-pads the output with spaces to prevent the input from "bleeding over" into output wherever an output line is shorter than a line being inputted.
  # @parmam str [String] The string to print.
  def self.puts_special(str)
    terminal_width = `tput cols`.to_i # From https://gist.github.com/KINGSABRI/4687864

    output_mode_normal!
    puts str.ljust(terminal_width, ' ')
    output_mode_special!
  end
end
