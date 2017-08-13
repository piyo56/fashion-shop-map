# デプロイ前に実行する必要がある。
desc 'execute before deploy'
task :db_create do
  on roles(:db) do |host|
    execute "mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS fsm_staging;'"
  end
end
