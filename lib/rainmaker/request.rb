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

      if options[:timeout_seconds].nil?
        options[:timeout_seconds] = Rainmaker.options[:timeout_seconds] unless Rainmaker.options[:timeout_seconds].nil?
      end

      options[:linkedin_token] = Rainmaker.options[:linkedin_token] unless Rainmaker.options[:linkedin_token].nil?
      options[:twitter_token] = Rainmaker.options[:twitter_token] unless Rainmaker.options[:twitter_token].nil?

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
    property :lt, :from => :linkedin_token
    property :tt, :from => :twitter_token
    property :email
  end
  end
end
