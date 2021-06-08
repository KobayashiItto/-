class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :about
      t.string :category
      t.text :url
      t.string :image

      t.timestamps
    end
  end
end
