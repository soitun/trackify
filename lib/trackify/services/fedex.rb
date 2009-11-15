module Fedex
  def self.get_response(number)
    uri            = URI.parse config_option(:fedex_url)
    http           = Net::HTTP.new uri.host, uri.port
    if uri.port == 443
      http.use_ssl  = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    data = "<?xml version='1.0' encoding='UTF-8' ?>
              <FDXTrack2Request xmlns:api='http://www.fedex.com/fsmapi' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='FDXTrack2Request.xsd'>
              <RequestHeader>
							  <AccountNumber>#{config_option(:fedex_account)}</AccountNumber>
							  <MeterNumber>#{config_option(:fedex_meter)}</MeterNumber>
						  </RequestHeader>
						  <PackageIdentifier>
							  <Value>#{number}</Value>
							  <Type></Type>
						  </PackageIdentifier>
						  <DetailScans>true</DetailScans>
						</FDXTrack2Request>";
    return http.post(uri.path, data).body
  end
end