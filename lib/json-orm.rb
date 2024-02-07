class JSONORM
  attr_reader :database, :transaction_data, :logger

  def initialize(database, log_file = 'orm.log')
    @database = database
    @transaction_data = nil
    @attributes = {}
    @logger = Logger.new(log_file)
  end

  # # Define a custom validator
  # JSONORM.register_validator('email') do |value|
  #   raise "Invalid email format" unless value.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  # end

  # # Define another custom validator, for example, for 'age'
  # JSONORM.register_validator('age') do |value|
  #   raise "Invalid age" unless value.is_a?(Integer) && value >= 0
  # end

  def self.register_validator(attribute, &block)
    @custom_validators ||= {}
    @custom_validators[attribute] = block
  end

  def self.custom_validators
    @custom_validators || {}
  end

  def all
    read_data
  end

  def find(id)
    read_data.detect { |record| record[:id] == id }
  end

  def where(attribute, value)
    ChainableQuery.new(self, read_data).where(attribute, value)
  end

  def create(attributes)
    attributes[:id] = next_id unless attributes.key?(:id)
    validate_attributes!(attributes)
    transaction_data.push(attributes)
    attributes
  end

  def update(id, new_attributes)
    validate_attributes!(new_attributes, false)
    transaction_data.map! do |record|
      if record[:id] == id
        updated_record = record.merge(new_attributes)
        validate_attributes!(updated_record, false) # Validate after merge
        updated_record
      else
        record
      end
    end
  end

  def delete(id)
    transaction_data.reject! { |record| record[:id] == id }
  end

  def begin_transaction
    @transaction_data = read_data.dup
  end

  def commit_transaction
    logger.info("Starting transaction commit")
    database.write(transaction_data)
    logger.info("Transaction committed successfully")
  rescue => e
    logger.error("Failed to commit transaction: #{e.message}")
    raise "Failed to commit transaction: #{e.message}"
  ensure
    @transaction_data = nil
  end

  def rollback_transaction
    @transaction_data = nil
  end

  private

  def read_data
    transaction_data || database.read
  end

  def next_id
    max_id = read_data.map { |record| record[:id] }.max || 0
    max_id + 1
  end

  def validate_attributes!(attributes, check_id = true)
    raise "Record must have an id" if check_id && !attributes[:id]

    attributes.each do |key, value|
      validate_attribute(key, value)
    end
  end

  # Update the validation method
  def validate_attribute(key, value)
    if self.class.custom_validators[key]
      self.class.custom_validators[key].call(value)
    else
      # Default validations (if any)
    end
  end
end


class ChainableQuery
  def initialize(orm, data)
    @orm = orm
    @data = data
  end

  def where(attribute, value)
    @data = @data.select { |record| record[attribute].to_s == value.to_s }
    self
  end

  def execute
    @data
  end
end