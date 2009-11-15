module Usps
  def self.get_response(number)
    return Net::HTTP.get("production.shippingapis.com",   "/ShippingAPI.dll?API=TrackV2&XML=<TrackFieldRequest%20USERID='#{config_option(:usps_user)}'%20PASSWORD='#{config_option(:usps_password)}'><TrackID%20ID='#{number}'></TrackID></TrackFieldRequest>")
  end
end