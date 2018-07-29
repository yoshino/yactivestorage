class Yactivestorage::CreateBlobs < ActiveRecord::Migration[5.2]
  def change
    create_table :yactivestorage_blobs do |t|
      t.string :key
      t.string :filename
      t.string :content_type
      t.integer :byte_size
      t.string :digest
      t.time :created_at

      t.index [ :token ], unique: true
    end
  end
end
