class ChangeColumnToItems < ActiveRecord::Migration
  def up
    remove_column :items, :image
    add_column :items, :image, :binary
    add_column :items, :image_content_type, :string
  end

  def down
    change_column :items, :image, :string
    remove_column :items, :image_content_type
  end
end
