$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative 'test_helpers/test_helper'
require_relative 'test_helpers/describe_and_it_blocks'

class ParseTest < Minitest::Test
  extend DescribeAndItBlocks

  describe "placeholder" do
    it "is true" do
      assert true, true
    end
  end
end
