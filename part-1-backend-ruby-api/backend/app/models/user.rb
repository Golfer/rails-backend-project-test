# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :company

  validates :email, :role, presence: true
  validates :email, uniqueness: { scope: :company_id }
end
