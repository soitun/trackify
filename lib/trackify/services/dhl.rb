module Dhl
  def self.get_response(number)
    uri            = URI.parse config_option(:dhl_url)
    http           = Net::HTTP.new uri.host, uri.port
    if uri.port == 443
      http.use_ssl  = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    data = "<?xml version='1.0'?>
			        <ECommerce action='Request' version='1.1'>
  			        <Requestor>
  				        <ID>#{config_option(:dhl_id)}</ID>
  				        <Password>#{config_option(:dhl_password)}</Password>
  			        </Requestor>
  			        <Track action='Get' version='1.0'>
  				        <Shipment>
  					        <TrackingNbr>#{number}</TrackingNbr>
  				        </Shipment>
  			        </Track>
		          </ECommerce>";
    return http.post(uri.path, data).body
  end
end