set :use_sudo, false

# As mentioned here:
# http://groups.google.com/group/github/browse_thread/thread/051fe195161d278d
`ssh-add`



set :stages, %w[testing staging production]
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

#default_run_options[:pty] = false
ssh_options[:forward_agent] = true

set :application, "Jetty"
set :repository,  "git@github.com:jlebensold/Jetty.git"
set :scm, "git"

#set :scm_verbose, true

set :user, "ec2-user"
set :branch, "master"

set :deploy_via, :remote_cache
set :normalize_asset_timestamps, false


require 'bundler/capistrano'
after 'deploy:setup', 'deploy:setup_shared'
#before 'deploy:finalize_update', 'deploy:create_release_symlinks'

#set :deploy_to, "/var/www/apps/#{application}"
#set :location, "ec2-50-16-36-65.compute-1.amazonaws.com"

# Set up SSH so it can connect to the EC2 node - assumes your SSH key is in ~/.ssh/id_rsa
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "testkey.pem")]

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Initial setup of the shared_path."
  task :setup_shared do
    run "mkdir -p #{shared_path}/config"
  end

  desc "Creates symlinks in the current release to assets and shared paths."
  task :create_release_symlinks do
    run "ln -nfs /www/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  desc "Start the Thin processes"
  task :start do
    run  <<-CMD
      cd /u/apps/Jetty/current; thin -s3 -e staging start -p 5000; RAILS_ENV=staging script/delayed_job start
    CMD
  end

  desc "Stop the Thin processes"
  task :stop do
    run <<-CMD
      cd /u/apps/Jetty/current; thin -s3 -e staging stop -p 5000; RAILS_ENV=staging script/delayed_job stop
    CMD
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd /u/apps/Jetty/current; thin -s3 -e staging restart -p 5000; RAILS_ENV=staging script/delayed_job restart
    CMD
  end


  desc "Search Remote Application Server Libraries"
  task :search_libs, :roles => :app do
    run "git ls-remote git@github.com:jlebensold/Jetty.git"
    run "ls -x1 /usr/lib | grep -i ssl"
  end
end
