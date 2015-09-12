module MemcacheKey
  class Key
    attr_reader :key, :bytes, :expires_time
    def initialize(key_data)
      @key, @bytes, @expires_time = key_data
    end
  end
end
