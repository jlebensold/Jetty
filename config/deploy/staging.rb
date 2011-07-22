set :rails_env, :staging

HOST = "staging.getjetty.com"
role :web, HOST
role :app, HOST
role :db,  HOST, :primary => true
