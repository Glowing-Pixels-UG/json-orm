require 'minitest/autorun'

# Dynamically determine the number of processors to use
require 'etc'
Minitest.parallel_executor = Minitest::Parallel::Executor.new(Etc.nprocessors)

# Require any other dependencies your tests need here
