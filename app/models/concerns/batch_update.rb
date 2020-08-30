module BatchUpdate
  extend ActiveSupport::Concern

  BATCH = 15

  module ClassMethods

    def batch_update(items, opt = {})
      raise StandardError.new "Error items data" unless items.is_a?(Hash)

      if validate_items?(items)
        items.each_slice(opt[:batch] || BATCH) do |batch|
          ActiveRecord::Base.connection.execute(sql_body(batch.to_h))
        end
        true
      else
        raise StandardError.new "Keys of objects cannot be different, keys must be the same"
      end
    end


    protected

    def sql_body(data)
      <<-SQL
        UPDATE #{self.table_name} 
          SET #{data.values.first.keys.map{ |key| build_case(key, data) }.join(', ')}
        WHERE id IN (#{data.keys.map(&:to_s).join(',')})
      SQL
    end

    def build_case(key, data)
      "#{key} = (CASE id #{data.map { |k, v| "WHEN #{k} THEN #{normalisation_value(v[key])}" }.join(' ')} END)"
    end

    def validate_items?(items)
      return true if items.empty?

      first_value_keys = items.values.first.keys
      items.values.all?{ |k| (k.keys & first_value_keys) == first_value_keys }
    end

    def normalisation_value(value)
      if value.is_a?(Integer) || value == !!value
        value
      elsif value.try(:date?)
        "TIMESTAMP '#{value}'"
      elsif value.nil?
        "NULL"
      else
        "'#{value}'"
      end
    end
  end
end
