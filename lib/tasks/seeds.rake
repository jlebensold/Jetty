task :seeds => :environment do
  Administrator.delete_all
  Administrator.create!(:email => "admin@jetty.com", :password => "abc123")  
end
