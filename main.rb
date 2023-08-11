require 'debug'
require_relative 'worlds_console/helper'
require_relative 'worlds_console/game'

WorldsConsole::Helper.hide_cursor!
WorldsConsole::Helper.output_mode_special!

begin
  WorldsConsole::Game.input_loop
ensure
  WorldsConsole::Helper.output_mode_normal!
  WorldsConsole::Helper.show_cursor!
end
