require "sqlite3"
require "fileutils"
require 'terminal-table'

def pt(rows)
  table = Terminal::Table.new :rows => rows
  puts table
end



db = SQLite3::Database.new "../mock1/db/development.sqlite3"

sql = %(insert into shops(name, mens, ladies, created_at, updated_at) values("test", "true", "false", "#{Time.now}", "#{Time.now}");)

pt db.execute(sql)
pt db.execute("select * from shops;")
db.close
