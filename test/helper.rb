require 'minitest/autorun'
require 'minitest/parallel'
require_relative '../lib/json-orm'
require_relative '../lib/json-orm/base_model'

# Dynamically determine the number of processors to use
require 'etc'
Minitest.parallel_executor = Minitest::Parallel::Executor.new(Etc.nprocessors)


# Setup and teardown methods for global test environment
Minitest::Test.class_eval do
  def before_setup
    super

    @db = JSONORM::DB.new('test_data.json', 'orm.test.log')
    @orm = JSONORM::ORM.new(@db, 'orm.test.log')
    @orm.begin_transaction
  end

  def after_teardown
    @orm.rollback_transaction
    File.delete('test_data.json') if File.exist?('test_data.json')
    File.delete('test_data.json.lock') if File.exist?('test_data.json.lock')
    File.delete('test_data.json.backup') if File.exist?('test_data.backup')
    super
  end
end