class RemoveDescriptionFromToDos < ActiveRecord::Migration
  def change
    remove_column :to_dos, :description
  end
end