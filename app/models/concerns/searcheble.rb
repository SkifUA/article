module Searcheble
  extend ActiveSupport::Concern

  included do
    class << self
      def search(params)

        search_params = if params.is_a? ActionController::Parameters
                          params.permit(:page, :group, orders: {}, scopes: {}).to_h
                      elsif params.nil?
                        {}
                      else
                        params.dup
                      end

        query = self

        search_params[:orders].map do |key, value|
          "#{key} #{direction(value)}" if self.allowed_orders.include?(key.to_sym) && value.present?
        end
            .compact
            .each do |order|
              query = query.order(order)
        end if search_params[:orders].present?

        search_params[:scopes].each do |key, value|
          query = query.send(key, value) if self.allowed_scopes.include?(key.to_sym) && value.present?
        end if search_params[:scopes].present?

        # query = query.group('articles.id')

        query.page(search_params[:page] || 1)
      end
    end
  end

end