class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Searcheble

  protected

  class << self
    def direction(order)
      ActiveRecord::QueryMethods::VALID_DIRECTIONS.include?(order) ? order : nil
    end

    def sanitize(ary)
      sanitize_sql_array(ary)
    end
  end
end
