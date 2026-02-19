# frozen_string_literal: true

require "rails_helper"

RSpec.describe Warehouse, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:company) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "factory" do
    it "builds a valid warehouse" do
      warehouse = build(:warehouse)
      expect(warehouse).to be_valid
    end
  end
end
