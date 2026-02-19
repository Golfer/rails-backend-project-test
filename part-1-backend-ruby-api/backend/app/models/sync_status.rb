# frozen_string_literal: true

class SyncStatus < ApplicationRecord
  self.table_name = "sync_status"

  belongs_to :company

  validates :entity_type, presence: true
end
