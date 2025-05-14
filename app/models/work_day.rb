class WorkDay < ApplicationRecord
  has_many :work_entries, dependent: :destroy
  validates :entry_date, presence: true, uniqueness: true
  validates :description, presence: true
end
