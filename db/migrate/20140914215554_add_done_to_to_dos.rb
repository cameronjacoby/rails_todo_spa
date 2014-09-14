class AddDoneToToDos < ActiveRecord::Migration
  def change
    add_column :to_dos, :done, :boolean
  end
end