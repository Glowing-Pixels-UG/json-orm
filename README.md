# JSON ORM

json-orm is a lightweight, JSON-based Object-Relational Mapping (ORM) system implemented in Ruby. It provides basic ORM functionalities like CRUD operations, transaction support, custom validations, and query chaining, making it suitable for small-scale projects or applications where a full-fledged database system isn't required.

## Development Notice

This project is in active development and is currently not recommended for production use. Contributions, suggestions, and feedback are welcome.

## Features

- CRUD operations on JSON files.
- Transaction support with commit and rollback.
- Custom attribute validation.
- Query chaining for advanced data filtering.
- Basic logging for monitoring and debugging.
- Thread-safe operations.

## Installation

Currently, JSONORM is not available as a gem. To use it, clone the repository and require it in your Ruby project:

```bash
git clone https://github.com/your-username/jsonorm.git
```

In your Ruby file:

```ruby
require_relative 'path/to/jsonorm/jsonorm'
```

## Usage

### Basic Operations

Here's how you can perform basic CRUD operations:

```ruby
# Initialize the database
db = JSONDatabase.new('your_data.json')
orm = JSONORM.new(db)

# Create a new record
orm.create({"name": "John Doe", "email": "john@example.com"})

# Find a record by ID
found_record = orm.find(1)

# Update a record
orm.update(1, {"name": "Jane Doe"})

# Delete a record
orm.delete(1)
```

### Transactions

```ruby
orm.begin_transaction
# Perform operations...
orm.commit_transaction
```

### Custom Validations

```ruby
# Define a custom validator
JSONORM.register_validator('email') do |value|
  # Validation logic...
end
```

### Query Chaining

```ruby
results = orm.where(:name, "John Doe").where(:age, 30).execute
```

## Testing

Testing is crucial for ensuring the reliability of JSONORM. Currently, we plan to use RSpec or Minitest for our testing suite. Tests will cover all core functionalities, including CRUD operations, transactions, and validations.

## Contributing

Contributions are welcome. Before contributing, please ensure you have:

- Written tests for new functionalities.
- Followed Ruby coding style and best practices.
- Updated the README if necessary.

## License

[MIT License](LICENSE)

## Acknowledgments

Thanks to all the contributors who have helped in developing JSONORM.

---

### Additional Notes:

- You may want to include a `LICENSE` file in your repository. Open-source projects often use licenses like MIT, Apache 2.0, or GPL.
- Consider setting up a contributing guide (`CONTRIBUTING.md`) to provide more detailed instructions for potential contributors.
- Depending on how the project evolves, you might need to update this documentation regularly to reflect new features or changes.
- Once you start implementing tests, update the "Testing" section with specifics on running tests and any test coverage metrics or CI/CD workflows you might have.