# ## Schema Information
#
# Table name: `references`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`target`**      | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`bible_id`**    | `bigint`           | `not null`
# **`book_id`**     | `bigint`           | `not null`
# **`chapter_id`**  | `bigint`           | `not null`
# **`heading_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_references_on_bible_id`:
#     * **`bible_id`**
# * `index_references_on_book_id`:
#     * **`book_id`**
# * `index_references_on_chapter_id`:
#     * **`chapter_id`**
# * `index_references_on_heading_id`:
#     * **`heading_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`bible_id => bibles.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`chapter_id => chapters.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`heading_id => headings.id`**
#
class Reference < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading, optional: true
  has_many :fragments, as: :fragmentable

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :target, presence: true
end
