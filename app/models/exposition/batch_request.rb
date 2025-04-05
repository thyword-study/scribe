# ## Schema Information
#
# Table name: `exposition_batch_requests`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`cancelled_at`**               | `datetime`         |
# **`cancelling_at`**              | `datetime`         |
# **`completed_at`**               | `datetime`         |
# **`expired_at`**                 | `datetime`         |
# **`expires_at`**                 | `datetime`         |
# **`failed_at`**                  | `datetime`         |
# **`finalizing_at`**              | `datetime`         |
# **`in_progress_at`**             | `datetime`         |
# **`input_file_uploaded_at`**     | `datetime`         | `not null`
# **`name`**                       | `string`           | `not null`
# **`requested_completed_count`**  | `integer`          |
# **`requested_failed_count`**     | `integer`          |
# **`requested_total_count`**      | `integer`          |
# **`status`**                     | `string`           | `not null`
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`batch_id`**                   | `string`           |
# **`error_file_id`**              | `string`           |
# **`input_file_id`**              | `string`           | `not null`
# **`output_file_id`**             | `string`           |
#
class Exposition::BatchRequest < ApplicationRecord
  # Validations
  validates :input_file_id, presence: true
  validates :input_file_uploaded_at, presence: true
  validates :name, presence: true
  validates :status, presence: true
end
