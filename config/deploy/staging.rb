set :rails_env, :staging

HOST = "ec2-72-44-48-52.compute-1.amazonaws.com"
role :web, HOST
role :app, HOST
role :db,  HOST, :primary => true
