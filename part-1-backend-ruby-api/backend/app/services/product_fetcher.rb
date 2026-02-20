# frozen_string_literal: true

class ProductFetcher
  def initialize(company)
    @company = company
  end

  def progress
    sync = @company.sync_statuses.find_by(entity_type: "Product")
    return { total: 0, fetched: 0 } unless sync

    { total: sync.total_count, fetched: sync.synced_count }
  end
end
