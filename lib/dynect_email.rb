require 'httparty'
require 'ostruct'
module DynectEmail
  class Error < StandardError; end

  include HTTParty
  base_uri 'http://emailapi.dynect.net/rest/json'
  class << self
    attr_accessor :api_key
  end

  def self.add_sender(email, apikey=nil)
    result = post("/senders", :body => { :apikey => apikey || DynectEmail.api_key, :emailaddress => email })

    handle_response(result)
  end

  def self.remove_sender(email, apikey=nil)
    result = post("/senders/delete", :body => { :apikey => apikey || DynectEmail.api_key, :emailaddress => email })

    handle_response(result)
  end

  def self.add_account(username, password, company, phone, options={})
    result = post("/accounts", :body => options.merge({:apikey => DynectEmail.api_key, :username => username, :password => password, :companyname => company, :phone => phone}))

    handle_response(result)
  end

  def self.remove_account(username)
    result = post("/accounts/delete", :body => {:apikey => DynectEmail.api_key, :username => username})

    handle_response(result)
  end

  # {:xheader1 => "X-header", xheader2 => ....}
  def self.set_headers(headers, apikey=nil)
    result = post("/accounts/xheaders", :body => headers.merge({:apikey => apikey || DynectEmail.api_key}))

    handle_response(result)
  end

  private
  def self.handle_response(response)
    message = response['response']['message']
    raise DynectEmail::Error, message unless message == 'OK'
    response['response']['data']
  end
end
