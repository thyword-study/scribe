# ## Schema Information
#
# Table name: `exposition_contents`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`context`**                    | `text`             | `not null`
# **`highlights`**                 | `text`             | `default([]), not null, is an Array`
# **`interpretation_type`**        | `string`           | `not null`
# **`people`**                     | `string`           | `default([]), not null, is an Array`
# **`places`**                     | `string`           | `default([]), not null, is an Array`
# **`reflections`**                | `text`             | `default([]), not null, is an Array`
# **`summary`**                    | `text`             | `not null`
# **`tags`**                       | `string`           | `default([]), not null, is an Array`
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`exposition_user_prompt_id`**  | `bigint`           | `not null`
# **`section_id`**                 | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_contents_on_exposition_user_prompt_id`:
#     * **`exposition_user_prompt_id`**
# * `index_exposition_contents_on_highlights` (_using_ gin):
#     * **`highlights`**
# * `index_exposition_contents_on_people` (_using_ gin):
#     * **`people`**
# * `index_exposition_contents_on_places` (_using_ gin):
#     * **`places`**
# * `index_exposition_contents_on_reflections` (_using_ gin):
#     * **`reflections`**
# * `index_exposition_contents_on_section_id`:
#     * **`section_id`**
# * `index_exposition_contents_on_tags` (_using_ gin):
#     * **`tags`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`exposition_user_prompt_id => exposition_user_prompts.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`section_id => sections.id`**
#
class Exposition::Content < ApplicationRecord
  # Associations
  belongs_to :section
  belongs_to :exposition_user_prompt
  has_many :exposition_alternative_interpretations, dependent: :destroy
  has_many :exposition_analyses, dependent: :destroy
  has_many :exposition_cross_references, dependent: :destroy
  has_many :exposition_insights, dependent: :destroy
  has_many :exposition_key_themes, dependent: :destroy
  has_many :exposition_personal_applications, dependent: :destroy

  # Validations
  validates :context, presence: true
  validates :highlights, presence: true
  validates :interpretation_type, presence: true
  validates :reflections, presence: true
  validates :section, presence: true
  validates :summary, presence: true
  validates :tags, presence: true

  # Enums
  enum :interpretation_type, { majority: "majority", minority:  "minority" }
end
