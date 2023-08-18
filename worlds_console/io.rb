module WorldsConsole
  class ::IO
    # Reads inputted characters one by one in a way that doesn't block output,
    # to allow output above the input line. Based on https://stackoverflow.com/a/9900628
    # @return [String] all inputted characters.
    def read_all_nonblock
      line = ''

      while char = self.read_nonblock(1, exception: false)
        return line if char == :wait_readable
        line << char
      end
    end
  end
end
