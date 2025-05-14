class AddDescriptionToWorkDays < ActiveRecord::Migration[8.0]
  def change
    add_column :work_days, :description, :text
  end
end
