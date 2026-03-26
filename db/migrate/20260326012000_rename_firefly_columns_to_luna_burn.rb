class RenameFireflyColumnsToLunaBurn < ActiveRecord::Migration[6.0]
  def change
    rename_column :artist_surveys, :has_attended_firefly, :has_attended_luna_burn
    rename_column :artist_surveys, :has_attended_firefly_desc, :has_attended_luna_burn_desc
    rename_column :voter_surveys, :has_attended_firefly, :has_attended_luna_burn
  end
end
