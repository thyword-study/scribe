# ## Schema Information
#
# Table name: `bible_chapters`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`number`**          | `integer`          | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`book_id`**         | `bigint`           | `not null`
# **`translation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_chapters_on_book_id`:
#     * **`book_id`**
# * `index_bible_chapters_on_translation_id`:
#     * **`translation_id`**
# * `index_bible_chapters_on_translation_id_and_book_id_and_number` (_unique_):
#     * **`translation_id`**
#     * **`book_id`**
#     * **`number`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`book_id => bible_books.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`translation_id => bible_translations.id`**
#
class Bible::Chapter < ApplicationRecord
  # Associations
  belongs_to :book
  belongs_to :translation
  has_many :footnotes, dependent: :restrict_with_error
  has_many :fragments, dependent: :restrict_with_error
  has_many :headings, dependent: :restrict_with_error
  has_many :references, dependent: :restrict_with_error
  has_many :sections, dependent: :restrict_with_error
  has_many :segments, dependent: :restrict_with_error
  has_many :verses, dependent: :restrict_with_error

  # Validations
  validates :book, presence: true
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :translation, presence: true

  # Returns the title of the chapter in the format "Chapter <number>".
  #
  # @return [String] the formatted chapter title
  def title
    "Chapter #{number}"
  end

  # Groups the segments of the chapter into sections.
  #
  # This method organizes the chapter's segments into logical sections using
  # `Segment.group_in_sections`. If sections already exist, it raises an error
  # unless `regroup` is enabled, in which case it deletes existing sections
  # before regrouping.
  #
  # @param regroup [Boolean] whether to delete and recreate sections if they already exist.
  # @raise [RuntimeError] if sections exist and `regroup` is false.
  # @raise [RuntimeError] if multiple distinct headings are found in a single section.
  #
  # @return [NilClass]
  #
  # @example Group segments into sections for a chapter
  #   chapter.group_segments_in_sections
  #
  # @example Regroup segments into sections after modifications
  #   chapter.group_segments_in_sections(regroup: true)
  def group_segments_in_sections!(regroup: false)
    if sections.any?
      raise RuntimeError, "Sections found and regrouping not enabled" unless regroup

      sections.destroy_all
      Rails.logger.info "Deleting all #{book.title} ##{number} sections to prepare for regrouping"
    end

    chapter_segments = segments.where(translation: translation, book: book).where.not(usx_style: "b").order(usx_position: :asc)
    segment_chunks = Bible::Segment.group_in_sections(chapter_segments)

    segment_chunks.each.with_index(1) do |chunk_segments, chunk_position|
      chunk_headings = chunk_segments.map { |segment| segment.heading }.uniq
      raise RuntimeError, "Multiple headings not expected!" if chunk_headings.size != 1

      heading = chunk_headings.first
      section = Bible::Section.create!(translation: translation, book: book, chapter: self, heading: heading, position: chunk_position)
      section.segments = chunk_segments
      Rails.logger.info "Created #{book.title} ##{number} Section #{section.id} Segments #{section.segments.ids.join(",")}"
    end
    Rails.logger.info "Sectioned #{book.title} ##{number}"

    nil
  end
end
