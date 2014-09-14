class AddDetailsToToDos < ActiveRecord::Migration
  def change
    add_column :to_dos, :details, :text
  end
end