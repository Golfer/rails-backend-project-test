# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :onboarding_processes, dependent: :destroy
  has_many :onboarding_step_submissions, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :warehouses, dependent: :destroy
  has_many :vendors, dependent: :destroy
  has_many :sync_statuses, dependent: :destroy

  validates :name, presence: true
end
