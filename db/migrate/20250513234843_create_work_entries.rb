class CreateWorkEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :work_entries do |t|
      t.references :work_day, null: false, foreign_key: true
      t.text :raw_text
      t.text :ai_summary
      t.string :ai_keywords

      t.timestamps
    end
  end
end
