module Ups
  def self.get_response(number)
    uri            = URI.parse config_option(:ups_url)
    http           = Net::HTTP.new uri.host, uri.port
    if uri.port == 443
      http.use_ssl  = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    data = "<?xml version='1.0'?>
              <AccessRequest xml:lang='en-US'>
                <AccessLicenseNumber>#{config_option(:ups_license_number)}</AccessLicenseNumber>
                <UserId>#{config_option(:ups_user)}</UserId>
                <Password>#{config_option(:ups_password)}</Password>
              </AccessRequest>
              <?xml version='1.0'?>
                <TrackRequest xml:lang='en-US'>
                  <Request>
                    <RequestAction>Track</RequestAction>
                    <RequestOption>activity</RequestOption>
                  </Request>
                  <TrackingNumber>#{number}</TrackingNumber>
                </TrackRequest>";
    return http.post(uri.path, data).body
  end
end