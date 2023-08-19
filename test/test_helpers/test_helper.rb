require 'rubygems'
require 'bundler/setup'

require 'debug'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new(detailed_skip: false)]


require 'pretty_diffs'

module Minitest
  class Test
    include PrettyDiffs
  end
end
