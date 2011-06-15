require 'helper'

describe Rainmaker::API do
  before do
    @keys = Rainmaker::Configuration::VALID_OPTIONS_KEYS
  end

  context "with module configuration" do
     before do
      Rainmaker.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Rainmaker.reset
    end

    it "should inherit module configuration" do
      api = Rainmaker::API.new
      @keys.each do |key|
        api.send(key).should == key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :api_key => 'api_key',
          :adapter => :typhoeus,
          :endpoint => 'http://tumblr.com/',
          :gateway => 'apigee-1111.apigee.com',
          :format => :xml,
          :proxy => 'http://erik:sekret@proxy.example.com:8080',
          :user_agent => 'Custom User Agent',
          :timeout_seconds => "Timeout Seconds",
          :linkedin_token => "LinkedIn Token",
          :twitter_token => "Twitter Token"
        }
      end

      context "during initialization"

        it "should override module configuration" do
          api = Rainmaker::API.new(@configuration)
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end

      context "after initilization" do

        it "should override module configuration after initialization" do
          api = Rainmaker::API.new
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end
      end
    end
  end
end
