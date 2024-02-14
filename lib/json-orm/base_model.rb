# frozen_string_literal: true

require 'logger'

module JSONORM
  class BaseModel
    include Validations
    class << self
      attr_accessor :attributes_list, :orm_instance

      def attributes(*names)
        @attributes_list ||= []
        names.each do |name|
          attr_accessor name unless method_defined?(name)
          @attributes_list << name unless @attributes_list.include?(name)
        end
        attr_accessor :id unless method_defined?(:id)
        @attributes_list << :id unless @attributes_list.include?(:id)
      end
    end

    def self.inherited(subclass)
      subclass.attributes_list = []
      subclass.orm_instance = nil
    end

    def initialize(attributes = {}, orm_instance:)
      raise 'ORM instance is required' unless orm_instance

      self.class.orm_instance = orm_instance
      @orm_instance = orm_instance
      attributes.each do |attr, value|
        send("#{attr}=", value) if self.class.attributes_list.include?(attr.to_sym)
      end
    end

    def save
      validate!
      data = self.class.attributes_list.each_with_object({}) do |attr, hash|
        hash[attr] = send(attr)
      end

      result = if id.nil? || id.to_s.empty?
                 @orm_instance.create(data)
               else
                 @orm_instance.update(id, data)
               end
      self.id = result[:id] if result.is_a?(Hash) && result.key?(:id)
      true
    rescue StandardError => e
      logger.error("Failed to save record for #{self.class.name}, Error: #{e.message}")
      raise "Failed to save record: #{e.message}"
    end

    private

    def logger
      @logger ||= Logger.new($stdout)
    end
  end
end
