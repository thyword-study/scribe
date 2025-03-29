class CreateExpositionInsights < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_insights do |t|
      t.references :exposition_content, null: false, foreign_key: { on_delete: :cascade }
      t.string :kind, null: false
      t.string :note, null: false

      t.timestamps
    end
  end
end
