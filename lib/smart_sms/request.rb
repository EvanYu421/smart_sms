# encoding: utf-8
require 'net/http'
require 'active_support/json'
require 'rest-client'
require 'service_gateway'

module SmartSMS
  # Module that manage requests
  module Request
    # Method that use `Net::HTTP.post_form` to perform `POST` action
    #
    def post(api, options = {})
      url = base_url + api
      params = {
        "message_content": options[:text],
        "country_code": "+86",
        "phone_no": "#{options[:mobile].gsub("+86","")}",
        "provider": SmartSMS.config.provider
      }

      headers = {
        "Sms-Service-Customer-Id": SmartSMS.config.app_id,
        "Sms-Service-Secret": SmartSMS.config.secrect
      }

      RestClient::Request.execute(
        method: :post, 
        url: url, 
        payload: params.to_query, 
        headers: headers,
        timeout: 5
      )
    end

   def post_by_gateway(path, options = {})
     params = {
       body: {
        "message_content": options[:text],
        "country_code": "+86",
        "phone_no": "#{options[:mobile].gsub("+86","")}"
       },
       headers: {
         "Sms-Service-Customer-Id": SmartSMS.config.app_id,
         "Sms-Service-Secret": SmartSMS.config.secrect
       }
     }
     
     ServiceGateway::Connection.new(
       service_id: 'sms_service',
       secret:     Settings.service_gateway.secret).post(path, params)
   end


    # Method that use `Net::HTTP.get` to perform `GET` action
    #
    def get(api, options = {})
      options[:apikey] = SmartSMS.config.api_key
      uri = URI.join(base_url, api)
      result Net::HTTP.get(uri, options)
    end

    private

    # Method that parse JSON to Hash
    #
    def result(body)
      begin
        ActiveSupport::JSON.decode body
      rescue => e
        {
          code: 502,
          msg: '内容解析错误',
          detail: e.to_s
        }
      end
    end

    # Base uri for yunpian API
    # Bsse uri for selfsms API
    def base_url
      # "http://yunpian.com/#{SmartSMS.config.api_version}/"
      SmartSMS.config.base_url
    end

    module_function :post, :post_by_gateway, :get, :result, :base_url
  end
end
