# frozen_string_literal: true

require "rails_helper"

RSpec.describe Company, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:onboarding_processes).dependent(:destroy) }
    it { is_expected.to have_many(:onboarding_step_submissions).dependent(:destroy) }
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it { is_expected.to have_many(:users).dependent(:destroy) }
    it { is_expected.to have_many(:warehouses).dependent(:destroy) }
    it { is_expected.to have_many(:vendors).dependent(:destroy) }
    it { is_expected.to have_many(:sync_statuses).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "factory" do
    it "builds a valid company" do
      company = build(:company)
      expect(company).to be_valid
    end

    it "creates a company with associations" do
      company = create(:company)
      expect(company.id).to be_present
      expect(company.name).to be_present
    end
  end
end
