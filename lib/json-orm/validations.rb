# frozen_string_literal: true

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
          value = send(attribute)
          case validator[:type]
          when :presence
            raise "Validation failed: #{attribute} can't be blank" if value.nil? || value.to_s.empty?
          when :format
            regex = validator[:options][:with]
            raise "Validation failed: #{attribute} is invalid" unless value.match?(regex)
          when :numericality
            raise "Validation failed: #{attribute} is not a number" unless value.is_a?(Numeric)
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
            raise "Validation failed: #{attribute} is not included in the list" unless in_set.include?(value)
          when :exclusion
            in_set = validator[:options][:in]
            raise "Validation failed: #{attribute} is reserved" if in_set.include?(value)
          when :custom
            custom_validation = validator[:options][:with]
            raise "Validation failed: #{attribute} is not valid" unless custom_validation.call(value)
          end
        end
      end
    end
  end
end
