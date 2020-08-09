module Searcheble
  extend ActiveSupport::Concern

  included do
    class << self
      def search(params)
        # TODO add pagination
        self.ransack(params).result(distinct: true)
      end
    end
  end

end