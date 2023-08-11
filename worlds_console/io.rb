module WorldsConsole
  class ::IO
    # To allow output above the input line.
    # Based on https://stackoverflow.com/a/9900628
    def read_all_nonblock
      line = ''

      while char = self.read_nonblock(1, exception: false)
        return line if char == :wait_readable
        line << char
      end
    end
  end
end
