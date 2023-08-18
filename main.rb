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
  Helper.io_mode_raw!
  Helper.hide_cursor!

  begin
    Runner.io_loop
  ensure
    Helper.show_cursor!
    Helper.io_mode_normal!
  end
end
