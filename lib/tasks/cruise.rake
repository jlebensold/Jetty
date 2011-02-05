desc 'Continuous build target'
task :cruise do
  out = ENV['CC_BUILD_ARTIFACTS']
  puts "out:::: "
  puts out
  mkdir_p out unless File.directory? out if out

  ENV['SHOW_ONLY'] = 'models,lib,helpers'
  Rake::Task["rcov"].invoke
  mv 'coverage', "#{out}/coverage coverage" if out

end

