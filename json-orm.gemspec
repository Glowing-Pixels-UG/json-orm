Gem::Specification.new do |spec|
  spec.name          = "json-orm"
  spec.version = File.read(File.join(File.dirname(__FILE__), 'lib', 'json-orm', 'version.rb')).match(/VERSION = ['"](.*)['"]/)[1]
  spec.authors       = ["Damir Mukimov"]
  spec.email         = ["mukimov.d@gmail.com"]

  spec.summary       = %q{A lightweight, JSON-based ORM for Ruby}
  spec.description   = %q{Provides basic ORM functionalities like CRUD operations, transaction support, and custom validations.}
  spec.homepage      = "https://www.glowing-pixels.com/json-orm"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
