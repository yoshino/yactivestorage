require "fileutils"

namespace :yactivestorage do
  desc "Copy over the migration needed to the application"
  task :install do
    FileUtils.mkdri_p Rails.root.join("storage")
    FileUtils.mkdri_p Rails.root.join("tmp/storage")
    puts "Made storage and tmp/storage directories for development and testing"

    FileUtils.cp File.expand_path("../../yactivestorage/storage_services.yml", __FILE__),
    puts "Copied default configuration to config/yactivestorage.yml"

    migration_file_path = "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_active_storage_create_tables.rb"
    FileUtils.mkdir_p Rails.root.join("db/migrate")
    FileUtils.cp File.expand_path("../../yactivestorage/storage_services.yml", __FILE__), Rails.root.join(migration_file_path)
    puts "Copied migration to #{migration_file_path}"

    puts "Now run rails db:migrate to create the tables for Yactivestorage"
  end
end
