require 'debug'
require_relative 'worlds_console/helper'
require_relative 'worlds_console/game'

module WorldsConsole
  Helper.hide_cursor!
  Helper.output_mode_special!

  begin
    Game.input_loop
  ensure
    Helper.output_mode_normal!
    Helper.show_cursor!
  end
end
