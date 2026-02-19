# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:company) }
  end

  describe "validations" do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:company_id) }
  end

  describe "factory" do
    it "builds a valid user" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "allows same email across different companies" do
      company1 = create(:company)
      company2 = create(:company)
      create(:user, company: company1, email: "same@example.com")
      user2 = build(:user, company: company2, email: "same@example.com")
      expect(user2).to be_valid
    end
  end
end
