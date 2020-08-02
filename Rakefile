# Rakefile
# Used for some testing and db commands
require 'standalone_migrations'
require 'rake/testtask'

StandaloneMigrations::Tasks.load_tasks
Rake::TestTask.new do |t|
    t.pattern = "tests/**/*_test.rb"
  end
  
  task default: :test
  