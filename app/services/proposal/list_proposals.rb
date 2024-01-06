class ListProposals < ActiveInteraction::Base
  # Logic for creating customers
  hash :filters, default: {}, strip: false
  integer :page_limit, default: 10
  integer :page, default: 1
  boolean :pagination_data_required, default: true
  string :sort_by, default: 'created_at'
  string :sort_type, default: 'desc'

  POSSIBLE_DIRECT_FILTERS = [:id, :customer_id]
  POSSIBLE_INDIRECT_FILTERS = []

  set_callback :execute, :before, lambda {
    self.filters = self.filters.deep_symbolize_keys.select { |_k, v| v.to_s.present? }
    unexpected_filters = (self.filters.keys - (POSSIBLE_DIRECT_FILTERS + POSSIBLE_INDIRECT_FILTERS))
    self.filters = self.filters.except(*unexpected_filters)
  }

  def execute
    query = get_query
    data = get_data(query)
    query = apply_direct_filters(query)
    query = apply_indirect_filters(query)

    pagination_data = get_pagination_data(query)

    {list: data}.merge!(pagination_data)
  end

  def get_query
    Proposal.order("#{self.sort_by} #{self.sort_type}").page(self.page).per(self.page_limit)
  end

  def get_data(query)
    data = query.as_json.map(&:deep_symbolize_keys)
  end

  def apply_direct_filters(query)
    direct_filters = self.filters.select { |k, _| POSSIBLE_DIRECT_FILTERS.include?(k.to_sym) }
    query.where(direct_filters)
  end

  def apply_indirect_filters(query)
    indirect_filters = self.filters.select { |k, _| POSSIBLE_INDIRECT_FILTERS.include?(k.to_sym) }
    indirect_filters.keys.each do |filter|
      query = send("apply_#{filter}_filter", query)
    end
    query
  end

  def get_pagination_data(query)
    return {} unless self.pagination_data_required

    {
      page: self.page,
      total: query.total_pages,
      total_count: query.total_count,
      page_limit: self.page_limit
    }
  end
end
