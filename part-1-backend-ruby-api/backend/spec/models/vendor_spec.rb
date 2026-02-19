# frozen_string_literal: true

require "rails_helper"

RSpec.describe Vendor, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "factory" do
    it "builds a valid vendor" do
      vendor = build(:vendor)
      expect(vendor).to be_valid
    end

    it "stores contact_info as hash" do
      vendor = create(:vendor, :with_contact)
      expect(vendor.contact_info).to include("email", "phone")
    end
  end
end
