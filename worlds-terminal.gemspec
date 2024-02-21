require_relative 'lib/worlds/terminal/version'

Gem::Specification.new do |spec|
  spec.name          = 'worlds-terminal'
  spec.version       = Worlds::Terminal::VERSION
  spec.authors       = ["Felipe Vogel"]
  spec.email         = ["fps.vogel@gmail.com"]

  spec.summary       = "A command-line interface for Worlds, a text-based world simulation and role-playing game toolkit."
  spec.homepage      = "https://github.com/fpsvogel/worlds-terminal"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_runtime_dependency 'pastel', '~> 0.8'

  spec.add_development_dependency 'debug', '~> 1.7'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.6'
  spec.add_development_dependency 'shoulda-context', '~> 2.0'
  spec.add_development_dependency 'pretty-diffs', '~> 1.0'
  spec.add_development_dependency 'rubycritic', '~> 4.7'

  spec.metadata['allowed_push_host'] = "https://rubygems.org"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "https://github.com/fpsvogel/worlds-terminal"
  spec.metadata['changelog_uri'] = "https://github.com/fpsvogel/worlds-terminal/blob/master/CHANGELOG.md"

  spec.files = Dir['lib/**/*.rb']

  spec.bindir = 'bin'
  spec.executables << 'worlds'

  spec.require_paths = ['lib']
end
