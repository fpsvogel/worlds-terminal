require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubycritic/rake_task'
require_relative 'lib/worlds/terminal/version'

task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end

Rake::TestTask.new(:warn) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

RubyCritic::RakeTask.new(:crit) do |t|
  t.paths = FileList['lib/worlds/**/*.rb']
  t.options = '--no-browser'
end

GEM_NAME = 'worlds-terminal'

task :build do
  system "gem build #{GEM_NAME}.gemspec"
end

task :install => :build do
  system "gem install #{GEM_NAME}-#{Worlds::Terminal::VERSION}.gem"
end

task :publish => :build do
  system "gem push #{GEM_NAME}-#{Worlds::Terminal::VERSION}.gem"
  system "rm *.gem"
end

task :clean do
  system "rm *.gem"
end
