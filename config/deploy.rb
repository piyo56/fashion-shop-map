# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'fashion-shop-map'
set :repo_url, 'https://github.com/piyo56/fashion-shop-map.git'
set :branch, 'master' # デフォルトがmasterなのでこの場合書かなくてもいいです。
set :deploy_to, "/home/ubuntu/fsm"
set :scm, :git # capistrano3からgitオンリーになった気がするのでいらないかも?

set :format, :pretty
set :log_level, :debug # :info or :debug
set :keep_releases, 3 # 何世代前までリリースを残しておくか

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
set :rbenv_path, '~/.rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
