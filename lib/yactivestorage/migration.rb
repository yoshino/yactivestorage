class Yactivestorage::CreateBlobs < ActiveRecord::Migration[5.2]
  def change
    create_table :rails_blobs do |t|
      t.string :key
      t.string :filename
      t.string :content_type
      t.integer :byte_size
      t.string :checksum
      t.time :created_at

      t.index [ :key ], unique: true
    end
  end
end
