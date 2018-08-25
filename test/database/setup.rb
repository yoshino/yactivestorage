require "yactivestorage/migration"
require_relative "create_users_migration"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
Yactivestorage::CreateTables.migrate(:up)
Yactivestorage::CreateUsers.migrate(:up)
