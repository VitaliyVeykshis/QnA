module Helpers
  module JsonHelpers
    def json_included_attributes_of(json, type, &block)
      attributes = json.dig(:included).map do |attr|
        attr.dig(:attributes) if attr.dig(:type) == type
      end.compact

      block_given? ? attributes.map { |attr| block.call(attr) } : attributes
    end

    def json_data_attributes(json, &block)
      attributes = json.dig(:data).map do |attr|
        attr.dig(:attributes)
      end

      block_given? ? attributes.map { |attr| block.call(attr) } : attributes
    end
  end
end
