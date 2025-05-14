class CreateWorkDays < ActiveRecord::Migration[8.0]
  def change
    create_table :work_days do |t|
      t.date :entry_date

      t.timestamps
    end
  end
end
