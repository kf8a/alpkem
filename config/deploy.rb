require 'bundler/capistrano'
load 'deploy/assets'

set :application, 'alpkem'
set :repository,  '/Users/bohms/code/alpkem'
set :scm, :git

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/var/u/apps/#{application}"

set :user, 'deploy'
set :use_sudo, false

set :branch, 'master'
set :deploy_via, :copy
set :git_enable_submodules, 1

role :app, 'oshtemo.kbs.msu.edu'
role :web, 'oshtemo.kbs.msu.edu'
role :db,  'oshtemo.kbs.msu.edu', primary: true

set :unicorn_binary, 'unicorn'
set :unicorn_config, "#{current_path}/config/unicorn/production.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  desc 'start unicorn server'
  task :start, roles: :app, except: { no_release: true } do
    run "cd #{current_path} && #{try_sudo} bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  desc 'stop unicorn server'
  task :stop, roles: :app, except: { no_release: true } do
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, roles: :app, except: { no_release: true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, roles: :app, except: { no_release: true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, roles: :app, except: { no_release: true } do
    stop
    start
  end

  after :deploy, :link_paperclip_storage
  after 'deploy:finalize_update', :link_production_db
  after 'deploy:finalize_update', :link_local_env
  after 'deploy:finalize_update', :link_upload_dir
  after 'deploy:finalize_update', :link_environment
end

# seed database
desc 'seed the database'
task :seed_database do
  run "cd #{current_path}; RAILS_ENV=production bundle exec rake db:seed"
end

# database.yml task
desc 'Link in the production database.yml'
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end
# local env
desc 'Link in the local_env.yml'
task :link_local_env do
  run "ln -nfs #{deploy_to}/shared/config/local_env.yml #{release_path}/config/local_env.yml"
end

desc 'link upload directory'
task :link_upload_dir do
  run "ln -nfs #{deploy_to}/shared/uploads #{release_path}/public/"
end

desc 'link upload env'
task :link_environment do
  run "ln -nfs #{deploy_to}/shared/env #{release_path}/.env"
end
