require 'mina/git'

set :domain, 'srv-nix.com'
set :deploy_to, '/tmp/srv-nix.com'
set :repository, 'https://github.com/wilful/srv-nix.com'
set :branch, 'master'
set :user, 'wilful'
set :port, '10322'

set :shared_paths, ['upload']

task :environment do
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/upload"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/upload"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:cleanup'

    to :launch do
      queue "jekyll build #{deploy_to}/#{current_path}/"
    end 
  end
end
