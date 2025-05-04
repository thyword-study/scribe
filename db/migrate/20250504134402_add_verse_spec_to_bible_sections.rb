class AddVerseSpecToBibleSections < ActiveRecord::Migration[8.0]
  def change
    add_column :bible_sections, :verse_spec, :string, default: nil, null: true
  end
end
