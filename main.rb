require 'debug'
require_relative 'worlds_console/helper'
require_relative 'worlds_console/runner'

# The execution starting point.
#
# To run, enter `ruby main.rb` in the terminal.
#
# Not namespaced as Worlds::Console because the Worlds module will eventually be
# split into its own gem, which can be used by more than this console interface
# (e.g. a web interface).
module WorldsConsole
  Helper.hide_cursor!
  Helper.output_mode_special!

  begin
    Runner.input_loop
  ensure
    Helper.output_mode_normal!
    Helper.show_cursor!
  end
end
