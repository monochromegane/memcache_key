module MemcacheKey
  class Items
    include Enumerable

    def initialize(host: Client::DEFAULT_HOST, port: Client::DEFAULT_PORT, timeout: Client::DEFAULT_TIMEOUT)
      @host    = host
      @port    = port
      @timeout = timeout
    end

    def each
      return to_enum(:each) unless block_given?

      client = memcached_client
      keys = []
      begin
        client.stats(:items).scan(/STAT items:(\d+):number (\d+)/).each do |slab|
          client.stats(:cachedump, *slab).scan(/^ITEM (.+?) \[(\d+) b; (\d+) s\]$/).each do |key_data|
            key = Key.new(key_data)
            keys << key
            yield key
          end
        end
      ensure
        client.close
      end
      keys
    end
  end

  private

  def memcached_client
    Client.new(host: @host, port: @port, timeout: @timeout)
  end
end
