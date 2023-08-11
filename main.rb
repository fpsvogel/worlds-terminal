require 'debug'
require_relative 'console_helper'
require_relative 'game'

ConsoleHelper.hide_cursor!
ConsoleHelper.output_mode_special!

begin
  Game.input_loop
ensure
  ConsoleHelper.output_mode_normal!
  ConsoleHelper.show_cursor!
end
