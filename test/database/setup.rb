require "yactivestorage/migration"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
Yactivestorage::CreateBlobs.migrate(:up)
