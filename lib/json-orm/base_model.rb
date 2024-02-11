# lib/jsonorm/base_model.rb
require_relative 'validations'

module JSONORM
  class BaseModel
    include Validations

    attr_accessor :id

    def initialize(attributes = {})
      attributes.each do |attr, value|
        send("#{attr}=", value) if respond_to?("#{attr}=")
      end
    end

    def save
      validate!
      # Insert logic to save the model to the database here.
      # This could involve calling a method on the ORM class to update or insert the record.
    end
  end
end
