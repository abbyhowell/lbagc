class RenameHowManyFirefliesColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :voter_surveys, :how_many_fireflies, :how_many_luna_burns
  end
end
