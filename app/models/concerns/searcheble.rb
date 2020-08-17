module Searcheble
  extend ActiveSupport::Concern

  included do
    class << self
      def search(params)
        self.ransack(params).result(distinct: true)
      end
    end
  end

end