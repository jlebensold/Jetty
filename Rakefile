# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
#require 'rcov/rcovtask'
#require 'simple-navigation'
#require 'metric_fu'
=begin
class Rcov::CodeCoverageAnalyzer
  def update_script_lines__
    if '1.9'.respond_to?(:force_encoding)
      SCRIPT_LINES__.each do |k,v|
        v.each { |src| src.force_encoding('utf-8') }
      end
    end
    @script_lines__ = @script_lines__.merge(SCRIPT_LINES__)
  end
end

 MetricFu::Configuration.run do |config|
        config.rcov[:test_files] = ['spec/**/*_spec.rb']
        config.rcov[:rcov_opts] << "-Ispec" # Needed to find spec_helper
end

if Rails.env.test?
  require 'rcov/rcovtask'

  if defined?(Rcov)
  end
end


desc "Create a cross-referenced code coverage report."
Rcov::RcovTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.rcov_opts << "--exclude \"test/*,gems/*,/Library/Ruby/*,config/*\" --rails"
end
=end



Jetty::Application.load_tasks
