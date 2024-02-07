module JSONORM
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
end