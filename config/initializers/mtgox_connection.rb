module MtGox::Connection
  # on 04/13 Mtgox changed it's api url. Since the guten-mtgox gem was still 
  # using the old address, I decided to patch it here:

    private

    def connection
      options = {
        :headers  => {
          :accept => "application/json",
          :user_agent => "mtgox gem #{MtGox::VERSION}"
        },
        :ssl => {:verify => false},
        :url => "https://data.mtgox.com",
      }

      Faraday.new(options) do |c|
        #c.use Faraday::Response::Logger
        c.use Faraday::Request::UrlEncoded
        c.use Faraday::Response::RaiseError
        c.use FaradayMiddleware::ParseJson
        c.use MtGox::Response::RaiseMtGoxError
        c.adapter(Faraday.default_adapter)
      end
  end
end
