require 'minitest/autorun'
require_relative '../lib/json-orm'

class JSONORMTest < Minitest::Test
  def setup
    @db = JSONORM::DB.new('test_data.json', 'orm.test.log')
    @orm = JSONORM::ORM.new(@db, 'orm.test.log')
    @orm.begin_transaction
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

  def test_create
    record = @orm.create({"name": "John Doe", "email": "john@example.com"})
    assert_equal "John Doe", record[:name]
    assert_equal "john@example.com", record[:email]
  end

  def test_read
    record = @orm.create({"name": "Jane Doe", "email": "jane@example.com"})
    found = @orm.find(record[:id])
    assert_equal "Jane Doe", found[:name]
    assert_equal "jane@example.com", found[:email]
  end

  def test_update
    record = @orm.create({"name": "Jim Doe", "email": "jim@example.com"})
    @orm.update(record[:id], {name: "James Doe"})
    updated = @orm.find(record[:id])

    assert_equal "James Doe", updated[:name]
    assert_equal "jim@example.com", updated[:email]
  end

  def test_delete
    record = @orm.create({"name": "Jack Doe", "email": "jack@example.com"})
    @orm.delete(record[:id])

    assert_nil @orm.find(record[:id])
  end

  def test_transaction_commit
    @orm.begin_transaction
    record = @orm.create({"name": "Jill Doe", "email": "jill@example.com"})
    @orm.commit_transaction
    assert_equal "Jill Doe", @orm.find(record[:id])[:name]
  end

  def test_transaction_rollback
    record = @orm.create({"name": "Joe Doe", "email": "joe@example.com"})
    @orm.rollback_transaction
    assert_nil @orm.find(record[:id])
  end

  def test_valid_email
    JSONORM::ORM.register_validator(:email) do |value|
      raise "Invalid email format" unless value.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
    end

    assert_raises("Invalid email format") do
      @orm.create({"name": "Invalid Email", "email": "invalid"})
    end
  end

  def test_valid_age
    JSONORM::ORM.register_validator(:age) do |value|
      raise "Invalid age" unless value.is_a?(Integer) && value >= 0
    end

    assert_raises(RuntimeError) do
      @orm.create({"name": "Invalid Age", "age": -5})
    end
  end

  def test_query_chaining
    @orm.create({"name": "Alice", "age": 30, "city": "Wonderland"})
    @orm.create({"name": "Bob", "age": 30, "city": "Gotham"})
    @orm.create({"name": "Charlie", "age": 40, "city": "Wonderland"})

    results = @orm.where(:age, 30).where(:city, "Wonderland").execute
    assert_equal 1, results.size
    assert_equal "Alice", results.first[:name]
  end


  def test_error_handling_on_write
    # Simulate an error during write operation, e.g., invalid data format
    @orm.create({"name": "Test", "email": "test@example.com"})
    @orm.database.stub :write, ->(_data) { raise IOError, "Write error" } do
      assert_raises(RuntimeError) { @orm.commit_transaction }
    end
  end
end
