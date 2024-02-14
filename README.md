# JSON ORM 🚀

`json-orm` is a Ruby gem providing a lightweight, JSON-based Object-Relational Mapping (ORM) system, primarily designed for simple data analytical applications 📊. It includes CRUD operations, transaction support, custom validations, and query chaining, ideal for small-scale projects.

🚧 **Important Development Notice** 🚧

While designed for simplicity and ease of use, `json-orm` hasn't been optimized for file size or fully vetted for reliability as a database storage solution. It's best used in contexts where these factors are not critical.

## Features ✨

- CRUD operations on JSON files
- Transaction support with commit and rollback
- Custom attribute validation
- Query chaining for advanced data filtering
- Basic logging for debugging
- Thread-safe operations

## Future Plans

- [ ] Refactor logging
- [x] Add tests to DB class
- [ ] Add RuboCop to GitHub Actions
- [ ] Clean up better after test
- [x] Improve test to validate reliability
- [x] Add Validations class

## Installation 🔧

Clone the repository and include it in your Ruby project:

```bash
git clone https://github.com/your-username/jsonorm.git
```

## Usage 📘

### Basic Operations

```ruby
db = JSONORM::JSONDB.new('your_data.json')
orm = JSONORM::ORM.new(db)

orm.create({name: "John Doe", email: "john@example.com"})
found_record = orm.find(1)
orm.update(1, {name: "Jane Doe"})
orm.delete(1)
```

### Transactions

```ruby
orm.begin_transaction
# Operations...
orm.commit_transaction
```

### JSONORM::Validations

The `JSONORM::Validations` module provides a flexible way to add validations to your Ruby objects. Here's how to use the newly added validators:

#### Length Validator
Checks if the length of a value is within a specified range.

**Usage:**

```ruby
validate :attribute_name, :length, minimum: 5, maximum: 10
```

**Example:**

```ruby
class User
  include JSONORM::Validations
  
  attr_accessor :name
  
  validate :name, :length, minimum: 3, maximum: 50
end

user = User.new
user.name = "Jo"
user.validate!  # Raises "Validation failed: name is too short (minimum is 3 characters)"
```

#### Inclusion Validator
Ensures a value is included in a specified set.

**Usage:**

```ruby
validate :attribute_name, :inclusion, in: [set_of_values]
```

**Example:**

```ruby
class Product
  include JSONORM::Validations
  
  attr_accessor :category
  
  validate :category, :inclusion, in: ['book', 'electronics', 'clothing']
end

product = Product.new
product.category = "food"
product.validate!  # Raises "Validation failed: category is not included in the list"
```

#### Exclusion Validator
Ensures a value is not included in a specified set.

**Usage:**

```ruby
validate :attribute_name, :exclusion, in: [set_of_values]
```

**Example:**

```ruby
class Account
  include JSONORM::Validations
  
  attr_accessor :username
  
  validate :username, :exclusion, in: ['admin', 'root']
end

account = Account.new
account.username = "admin"
account.validate!  # Raises "Validation failed: username is reserved"
```

#### Custom Validator
Allows for custom validation logic through a lambda or proc.

**Usage:**

```ruby
validate :attribute_name, :custom, with: lambda { |value| some_custom_condition }
```

**Example:**

```ruby
class Order
  include JSONORM::Validations
  
  attr_accessor :total_price
  
  validate :total_price, :custom, with: ->(value) { value > 0 && value < 10000 }
end

order = Order.new
order.total_price = -5
order.validate!  # Raises "Validation failed: total_price is not valid"
```

#### Integrating Validators

To integrate these validators into your `validate!` method, simply add the cases as shown in the initial response to handle each validation type. Ensure that your `validate!` method checks for each validator type and applies the corresponding validation logic.

### Query Chaining

```ruby
results = orm.where(age: 30).where(city: "Wonderland").execute
```

## Testing with MiniTest 🧪

Tests are located in the `test` directory. Run them using MiniTest to ensure reliability.

## Contributing 🤝

Contributions are welcome. Please ensure to follow Ruby coding style and best practices, and write tests for new functionalities.

## License

Distributed under the MIT License.