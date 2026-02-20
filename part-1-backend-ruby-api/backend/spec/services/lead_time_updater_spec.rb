# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeadTimeUpdater do
  let(:company) { create(:company) }

  describe "#call" do
    it "updates all company products lead_time_days when values is a hash with integer lead_time_days" do
      create(:product, company: company, lead_time_days: 5)
      create(:product, company: company, lead_time_days: 10)
      other_company = create(:company)
      create(:product, company: other_company, lead_time_days: 99)

      described_class.new(company, { lead_time_days: 14 }).call

      expect(company.products.pluck(:lead_time_days)).to all(eq(14))
      expect(other_company.products.pluck(:lead_time_days)).to eq([ 99 ])
    end

    it "does nothing when values is not a Hash" do
      create(:product, company: company, lead_time_days: 5)

      described_class.new(company, nil).call
      described_class.new(company, "invalid").call

      expect(company.products.pluck(:lead_time_days)).to eq([ 5 ])
    end

    it "does nothing when lead_time_days is not an integer" do
      create(:product, company: company, lead_time_days: 5)

      described_class.new(company, { lead_time_days: "7" }).call
      expect(company.products.pluck(:lead_time_days)).to eq([ 5 ])

      described_class.new(company, {}).call
      expect(company.products.pluck(:lead_time_days)).to eq([ 5 ])
    end
  end
end
