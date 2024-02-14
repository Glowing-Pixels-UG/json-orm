module JSONORM
  module Validations
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def validate(attribute, validation_type, options = {})
        @validators ||= {}
        @validators[attribute] ||= []
        @validators[attribute] << { type: validation_type, options: options }
      end

      def validators
        @validators || {}
      end
    end

    def validate!
      self.class.validators.each do |attribute, validators|
        validators.each do |validator|
          value = self.send(attribute)
          case validator[:type]
          when :presence
            raise "Validation failed: #{attribute} can't be blank" if value.nil? || value.to_s.empty?
          when :format
            regex = validator[:options][:with]
            raise "Validation failed: #{attribute} is invalid" unless value.match?(regex)
          when :numericality
            unless value.is_a?(Numeric)
              raise "Validation failed: #{attribute} is not a number"
            end
          when :length
            min_length = validator[:options][:minimum] || 0
            max_length = validator[:options][:maximum] || Float::INFINITY
            actual_length = value.to_s.length
            if actual_length < min_length
              raise "Validation failed: #{attribute} is too short (minimum is #{min_length} characters)"
            elsif actual_length > max_length
              raise "Validation failed: #{attribute} is too long (maximum is #{max_length} characters)"
            end
          when :inclusion
          in_set = validator[:options][:in]
          unless in_set.include?(value)
            raise "Validation failed: #{attribute} is not included in the list"
          end
          when :exclusion
            in_set = validator[:options][:in]
            if in_set.include?(value)
              raise "Validation failed: #{attribute} is reserved"
            end
          when :custom
            custom_validation = validator[:options][:with]
            unless custom_validation.call(value)
              raise "Validation failed: #{attribute} is not valid"
            end
          end
        end
      end
    end
  end
end
