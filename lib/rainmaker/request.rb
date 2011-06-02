require "hashie"

module Rainmaker
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options={}, raw=false)
      request(:get, path, options, raw)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, raw=false)
		#check to see if apiKey and timeoutSeconds options were passed in
		#set them from Rainmaker.options if not

		options[:api_key] = Rainmaker.options[:api_key] if options[:api_key].nil?
		options[:timeout_seconds] = Rainmaker.options[:timeout_seconds] if options[:api_key].nil?

		query_params = QueryParams.new(options)

		response = connection(raw).send(method) do |request|
			request.url(formatted_path(path), query_params)
      	end

		raw ? response : response.body
    end

    def formatted_path(path)
      [path, format].compact.join('.')
	end

	class QueryParams < Hashie::Trash
		property :apiKey, :from => :api_key
		property :timeoutSeconds, :from => :timeout_seconds
		property :email
	end
  end
end
