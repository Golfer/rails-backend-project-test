# frozen_string_literal: true


class SyncProgressAggregator
  FETCHERS = {
    "Product" => ProductFetcher,
    "Warehouse" => WarehouseFetcher
  }.freeze

  def initialize(company)
    @company = company
  end

  def progress_list
    FETCHERS.map do |entity_type, fetcher_class|
      data = fetcher_class.new(@company).progress
      sync = @company.sync_statuses.find_by(entity_type: entity_type)
      {
        entity_type: entity_type,
        total_count: data[:total],
        synced_count: data[:fetched],
        is_finished: sync.present? && sync.is_finished
      }
    end
  end
end
