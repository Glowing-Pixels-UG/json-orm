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
- [ ] Add tests to DB class
- [ ] Clean up better after test
- [ ] Improve test to validate reliability
- [ ] Add Validations class

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

### Custom Validations

```ruby
JSONORM.register_validator(:email) do |value|
  # Validation logic...
end
```

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