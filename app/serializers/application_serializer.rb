class ApplicationSerializer
  include ActiveModel::Serializers::JSON

  # Default serialized object
  attr_reader :object
  attr_reader :meta


  def initialize(obj, meta: {})
    @object = obj
    @meta = meta
  end

  # Return list of all Attributes
  def attributes
    @attributes ||= self.class.attributes.map { |k, _| [k, nil] }.to_h
  end

  def as_json(options = {})
    super(options)
  end

  class << self
    attr_reader :attributes

    # Wrap list
    def wrap(objects, meta: {})
      if objects.respond_to?(:to_ary)
        (objects.to_ary || [objects]).map { |o| self.new(o, meta: meta) }
      else
        self.new(objects, meta: meta)
      end
    end

    # DSL to set attribute
    # opt[:source]
    # opt[:field]
    # opt[:with]
    def attribute(attr, opt = {})
      @attributes ||= {}
      @attributes[attr.to_s] = { source: opt[:source], field: opt[:field] }

      if opt[:source].present?
        define_serialization_getter(attr, opt[:source], opt)
      end
    end


    private

    # DSL to create getter + wrapper
    def define_serialization_getter(attr, source, opt = {})
      define_method attr do
        value = self.send(source).try(opt[:field] || attr)
        return value unless opt[:with].present?

        if value.nil?
          value
        elsif opt[:if].present? && !value.send(opt[:if])
          nil
        elsif opt[:with].is_a?(Class) && (opt[:with] <= ApplicationSerializer)
          opt[:with].wrap(value)
        else
          opt[:with].call(value)
        end
      end
    end
  end
end
