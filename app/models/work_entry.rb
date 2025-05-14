class WorkEntry < ApplicationRecord
  belongs_to :work_day
  validates :raw_text, presence: true
end
