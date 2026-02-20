# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :company

  has_secure_password validations: false

  validates :email, :role, presence: true
  validates :email, uniqueness: { scope: :company_id }
  validates :password, length: { minimum: 8 }, presence: true, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
