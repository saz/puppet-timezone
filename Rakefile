require 'puppetlabs_spec_helper/rake_tasks'

# load optional tasks for releases
# only available if gem group releases is installed
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'

desc 'Auto-correct puppet-lint offenses'
task 'lint:auto_correct' do
  Rake::Task[:lint_fix].invoke
end

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run tests'
task test: [:release_checks]

namespace :check do
  desc 'Check for trailing whitespace'
  task :trailing_whitespace do
    Dir.glob('**/*.md', File::FNM_DOTMATCH).sort.each do |filename|
      next if filename =~ %r{^((modules|acceptance|\.?vendor|spec/fixtures|pkg)/|REFERENCE.md)}
      File.foreach(filename).each_with_index do |line, index|
        if line =~ %r{\s\n$}
          puts "#{filename} has trailing whitespace on line #{index + 1}"
          exit 1
        end
      end
    end
  end
end
Rake::Task[:release_checks].enhance ['check:trailing_whitespace']

desc "Run main 'test' task and report merged results to coveralls"
task test_with_coveralls: [:test] do
  if Dir.exist?(File.expand_path('../lib', __FILE__))
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    Rake::Task['coveralls:push'].invoke
  else
    puts 'Skipping reporting to coveralls.  Module has no lib dir'
  end
end

desc 'Generate REFERENCE.md'
task :reference, [:debug, :backtrace] do |t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

# vim: syntax=ruby
