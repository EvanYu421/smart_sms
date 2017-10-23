# encoding: utf-8

module SmartSMS
  # Module that contains methods to generate fake message
  #
  module FakeSMS
    module_function

    # This will generate fake sms with all necessary attributes
    #
    # Options:
    #
    #   * mobile: mobile number
    #   * code:   verification code
    #   * company: assigned company, format is【company】
    #
    def build_fake_sms(mobile, text)
      {
        'sid'               => SecureRandom.uuid,
        'mobile'            => mobile,
        'send_time'         => Time.zone.now,
        'text'              => text,
        'send_status'       => 'SUCCESS',
        'report_status'     => 'UNKNOWN',
        'fee'               => 1,
        'user_receive_time' => nil,
        'error_msg'         => nil
      }
    end
  end
end
