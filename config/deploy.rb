set :application, 'fashion-shop-map'
set :repo_url, 'https://github.com/piyo56/fashion-shop-map.git'
set :branch, 'master' # デフォルトがmasterなのでこの場合書かなくてもいいです。
set :deploy_to, "/home/ubuntu/fsm"
set :rails_env, 'staging'

set :format, :pretty
set :log_level, :debug # :info or :debug
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
set :keep_releases, 5 

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_roles, :all

set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{current_path}/config/unicorn/unicorn.rb"
set :unicorn_rack_env, 'deployment' # "development", "deployment", or "none"

namespace :deploy do
  desc 'Restart application'
  task :restart do
  end
  after :publishing, 'deploy:restart'
end
