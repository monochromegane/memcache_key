module MemcacheKey
  class Client
    DEFAULT_HOST    = 'localhost'
    DEFAULT_PORT    = 11211
    DEFAULT_TIMEOUT = 3

    def initialize(host: 'localhost', port: 11211, timeout: 3)
      @client = Net::Telnet.new('Host' => host, 'Port' => port, 'Timeout' => timeout)
    end

    def stats(type='', *args)
      @client.cmd('String' => command(:stats, type, *args), 'Match' => /^END/)
    end

    def close
      @client.close
    end

    private

    def command(cmd, *args)
      "#{cmd} #{args.join(' ')}"
    end
  end
end

