set :rails_env, :staging

HOST = "ec2-50-16-36-65.compute-1.amazonaws.com"
role :web, HOST
role :app, HOST
role :db,  HOST, :primary => true
