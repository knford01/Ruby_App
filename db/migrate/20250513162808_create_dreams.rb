class CreateDreams < ActiveRecord::Migration[8.0]
  def change
    create_table :dreams do |t|
      t.text :raw_text
      t.text :ai_summary
      t.string :ai_keywords

      t.timestamps
    end
  end
end
