require "fileutils"

namespace :yactivestorage do
  desc "Copy over the migration needed to the application"
  task :migration do
    FileUtils.cp \
      File.expand_path("../../yactivestorage/migration.rb", __FILE__),
      Rails.root.join("db/migrate/#{Time.now.utc.srtftime(%Y%m%d%H%M%S)}_yactivestorage_create_tables.rb")

    puts "Now run rails db:migrate to create the tables for Yactivestorage"
  end
end
