# frozen_string_literal: true

require_relative 'helper'
require 'debug'

module JSONORM
  class TestModel < BaseModel
    attributes :name, :email, :age
    validate :name, :presence, {}
    validate :email, :format, with: /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
    validate :age, :numericality, greater_than_or_equal_to: 0
  end
end

class BaseModelTest < Minitest::Test
  def setup
    @model = JSONORM::TestModel.new({ name: 'Test User', email: 'user@example.com', age: 30 }, orm_instance: @orm)
  end

  def test_valid_model_saves_successfully
    assert @model.save
  end

  def test_presence_validation_failure
    @model = JSONORM::TestModel.new({ name: nil }, orm_instance: @orm)
    assert_raises("Failed to save record: Validation failed: name can't be blank") { @model.save }
  end

  def test_email_format_validation_failure
    @model = JSONORM::TestModel.new({ email: 'invalid_email' }, orm_instance: @orm)
    assert_raises('Failed to save record: Validation failed: email is invalid') { @model.save }
  end

  def test_numericality_validation_failure
    @model = JSONORM::TestModel.new({ age: -1 }, orm_instance: @orm)
    assert_raises('Failed to save record: Validation failed: age is not greater than or equal to 0') { @model.save }
  end

  def test_attribute_assignment
    assert_equal 'Test User', @model.name
    assert_equal 'user@example.com', @model.email
    assert_equal 30, @model.age
  end
end
