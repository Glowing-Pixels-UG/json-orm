require 'minitest/autorun'
require_relative '../lib/json-orm'
require_relative '../lib/json-orm/base_model'

class TestUser < JSONORM::BaseModel
  attr_accessor :name, :email, :age

  validate :name, :presence, {}
  validate :email, :format, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validate :age, :numericality, greater_than_or_equal_to: 0
end

class JSONORMValidationTest < Minitest::Test
  def setup
    @db = JSONORM::DB.new('test_data.json', 'orm.test.log')
    @orm = JSONORM::ORM.new(@db, 'orm.test.log')
    @orm.begin_transaction
    # Registering validators for new test cases
    JSONORM::ORM.register_validator(:length) do |attribute, value, options|
      min_length = options[:minimum] || 0
      max_length = options[:maximum] || Float::INFINITY
      unless value.length.between?(min_length, max_length)
        raise "#{attribute} length must be between #{min_length} and #{max_length}"
      end
    end

    JSONORM::ORM.register_validator(:inclusion) do |attribute, value, options|
      in_set = options[:in]
      raise "#{attribute} is not included in the list" unless in_set.include?(value)
    end

    JSONORM::ORM.register_validator(:exclusion) do |attribute, value, options|
      in_set = options[:in]
      raise "#{attribute} is reserved and cannot be used" if in_set.include?(value)
    end

    JSONORM::ORM.register_validator(:custom) do |attribute, value, options|
      custom_logic = options[:with]
      raise "#{attribute} is not valid according to custom logic" unless custom_logic.call(value)
    end
  end
    def after_tests
      File.delete('test_data.json.backup') if File.exist?('test_data.backup')
    end

    def teardown
      @orm.rollback_transaction
      File.delete('test_data.json') if File.exist?('test_data.json')
      File.delete('test_data.json.lock') if File.exist?('test_data.json.lock')
      File.delete('test_data.json.backup') if File.exist?('test_data.backup')
    end

def test_presence_validation
    user = TestUser.new
    assert_raises(RuntimeError) { user.save }
  end

  def test_email_format_validation
    user = TestUser.new(email: "invalid")
    assert_raises(RuntimeError) { user.save }
  end

  def test_age_numericality_validation
    user = TestUser.new(age: -1)
    assert_raises(RuntimeError) { user.save }
  end


end
