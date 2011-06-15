require 'helper'

describe Rainmaker do
  after do
    Rainmaker.reset
  end

  context "when delegating to a client" do

    before do
    Rainmaker.configure do |config|
      config.api_key = "api_key"
    end

    stub_get("person.json").
      with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com"}).
      to_return(:body => fixture("person.json"), :headers => {:content_type => "application/json; charset=utf-8"})

    stub_get("person.json").
      with(:query => {:apiKey => "passed_api_key", :email => "brawest@gmail.com", :timeoutSeconds => "passed_timeout"}).
      to_return(:body => fixture("person.json"), :headers => {:content_type => "application/json; charset=utf-8"})

    stub_get("person.json").
      with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :timeoutSeconds => "from_config"}).
      to_return(:body => fixture("person.json"), :headers => {:content_type => "application/json; charset=utf-8"})

    stub_get("person.json").
      with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :lt => "from_config"}).
      to_return(:body => fixture("person.json"), :headers => {:content_type => "application/json; charset=utf-8"})

    stub_get("person.json").
      with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :tt => "from_config"}).
      to_return(:body => fixture("person.json"), :headers => {:content_type => "application/json; charset=utf-8"})

    stub_get("person.json").
      with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :timeoutSeconds => "0"}).
      to_return(:body => fixture("person.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      Rainmaker.person("brawest@gmail.com")
      a_get("person.json")
      .with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com"})
      .should have_been_made
    end

    it "should get person with provided api_key and timeout_seconds" do
      Rainmaker.person("brawest@gmail.com", {:api_key => "passed_api_key", :timeout_seconds => "passed_timeout"})
      a_get("person.json")
     .with(:query => {:apiKey => "passed_api_key", :email => "brawest@gmail.com", :timeoutSeconds => "passed_timeout"})
     .should have_been_made
    end

    it "should use timeout_seconds from config if not passed in" do
      Rainmaker.configure do |config|
        config.timeout_seconds = "from_config"
      end

      Rainmaker.person("brawest@gmail.com")
      a_get("person.json")
      .with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :timeoutSeconds => "from_config"})
      .should have_been_made
    end
    
    it "should use linkedin_token from config if existing" do
      Rainmaker.configure do |config|
        config.linkedin_token = "from_config"
      end
      
      Rainmaker.person("brawest@gmail.com")
      a_get("person.json")
      .with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :lt => "from_config"})
      .should have_been_made
    end

    it "should use twitter_token from config if existing" do
      Rainmaker.configure do |config|
        config.twitter_token = "from_config"
      end
      
      Rainmaker.person("brawest@gmail.com")
      a_get("person.json")
      .with(:query => {:apiKey => "api_key", :email => "brawest@gmail.com", :tt => "from_config"})
      .should have_been_made
    end

    it "should return the same results as a client" do
      Rainmaker.person("brawest@gmail.com").should == Rainmaker::Client.new.person("brawest@gmail.com")
    end

  end

  describe '.respond_to?' do
    it 'takes an optional include private argument' do
      Rainmaker.respond_to?(:client, true).should be_true
    end
  end

  describe ".client" do
    it "should be a Rainmaker::Client" do
      Rainmaker.client.should be_a Rainmaker::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      Rainmaker.adapter.should == Rainmaker::Configuration::DEFAULT_ADAPTER
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Rainmaker.adapter = :typhoeus
      Rainmaker.adapter.should == :typhoeus
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      Rainmaker.endpoint.should == Rainmaker::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Rainmaker.endpoint = 'http://tumblr.com/'
      Rainmaker.endpoint.should == 'http://tumblr.com/'
    end
  end

  describe ".format" do
    it "should return the default format" do
      Rainmaker.format.should == Rainmaker::Configuration::DEFAULT_FORMAT
    end
  end

  describe ".format=" do
    it "should set the format" do
      Rainmaker.format = 'xml'
      Rainmaker.format.should == 'xml'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Rainmaker.user_agent.should == Rainmaker::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Rainmaker.user_agent = 'Custom User Agent'
      Rainmaker.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do

    Rainmaker::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Rainmaker.configure do |config|
          config.send("#{key}=", key)
          Rainmaker.send(key).should == key
        end
      end
    end
  end
end
