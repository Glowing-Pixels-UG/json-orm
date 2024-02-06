class JSONORM
  attr_reader :database, :transaction_data

  def initialize(database)
    @database = database
    @transaction_data = nil
  end

  def all
    read_data
  end

  def find(id)
    read_data.detect { |record| record['id'] == id }
  end

  def where(attribute, value)
    read_data.select { |record| record[attribute.to_s] == value }
  end

  def create(attributes)
    attributes['id'] = next_id unless attributes.key?('id')
    validate_attributes!(attributes, false)
    transaction_data.push(attributes)
    attributes
  end

  def update(id, new_attributes)
    validate_attributes!(new_attributes, false)
    transaction_data.map! do |record|
      record['id'] == id ? new_attributes.merge('id' => id) : record
    end
  end

  def delete(id)
    transaction_data.reject! { |record| record['id'] == id }
  end

  def begin_transaction
    @transaction_data = read_data.dup
  end

  def commit_transaction
    database.write(transaction_data)
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
    max_id = read_data.map { |record| record['id'] }.max || 0
    max_id + 1
  end

  def validate_attributes!(attributes, check_id = true)
    # Add more validation rules here
  end
end
