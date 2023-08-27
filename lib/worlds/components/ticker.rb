module Worlds
  module Components
    class Ticker < Component
      def update(ms)
        @tick = !@tick
        { color: :blue, content: @tick ? 'Tick!' : 'Tock!' }
      end
    end
  end
end
