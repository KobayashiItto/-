class AddImageToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :image, :string
  end
end
