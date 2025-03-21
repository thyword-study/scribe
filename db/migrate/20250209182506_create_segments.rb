class CreateSegments < ActiveRecord::Migration[8.0]
  def change
    create_table :segments do |t|
      t.references :bible, null: false, foreign_key: { on_delete: :restrict }
      t.references :book, null: false, foreign_key: { on_delete: :restrict }
      t.references :chapter, null: false, foreign_key: { on_delete: :restrict }
      t.references :heading, null: false, foreign_key: { on_delete: :restrict }
      t.integer :usx_node_id, null: false
      t.string :usx_style, null: false

      t.timestamps
    end
  end
end
