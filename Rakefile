require 'puppetlabs_spec_helper/rake_tasks'

# load optional tasks for releases
# only available if gem group releases is installed
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
end

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run tests'
task test: [:release_checks]

desc 'Generate REFERENCE.md'
task :reference, [:debug, :backtrace] do |t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

# vim: syntax=ruby
