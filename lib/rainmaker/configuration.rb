require 'faraday'

module Rainmaker
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Rainmaker::API}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :api_key,
      :timeout_seconds,
      :endpoint,
      :format,
      :gateway,
      :proxy,
      :linkedin_token,
      :twitter_token,
      :user_agent].freeze

    # An array of valid request/response formats
    VALID_FORMATS = [
      :json,
      :xml].freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # By default, don't set an application key
    DEFAULT_API_KEY = nil

    # By default, don't set a timeout
    DEFAULT_TIMEOUT_SECONDS = nil

    # The endpoint that will be used to connect if none is set
    #
    DEFAULT_ENDPOINT = 'http://api.rainmaker.cc/v1/'.freeze

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is preferred over XML because it is more concise and faster to parse.
    DEFAULT_FORMAT = :json

     # By default, don't use a proxy server
    DEFAULT_PROXY = nil
    
    # By default, no linkedin token
    DEFAULT_LINKEDIN_TOKEN = nil
    
    # By default, no twitter token
    DEFAULT_TWITTER_TOKEN = nil

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Rainmaker Ruby Gem".freeze

    DEFAULT_GATEWAY = nil

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k) }
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter            = DEFAULT_ADAPTER
      self.api_key            = DEFAULT_API_KEY
      self.endpoint           = DEFAULT_ENDPOINT
      self.format             = DEFAULT_FORMAT
      self.proxy              = DEFAULT_PROXY
      self.user_agent         = DEFAULT_USER_AGENT
      self.gateway            = DEFAULT_GATEWAY
      self.timeout_seconds    = DEFAULT_TIMEOUT_SECONDS
      self.twitter_token      = DEFAULT_TWITTER_TOKEN
      self.linkedin_token     = DEFAULT_LINKEDIN_TOKEN
      self
    end
  end
end