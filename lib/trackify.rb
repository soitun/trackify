SITE_CONFIG = YAML::load(File.open("#{RAILS_ROOT}/config/trackify_config.yml")).with_indifferent_access

def config_option(p, env = nil) 
	env ||= RAILS_ENV
	raise "No configuration for environment \"#{env}\"" if SITE_CONFIG[env].nil?	
	inherit_env = SITE_CONFIG[env]["inherit"]
	SITE_CONFIG[env][p] || (inherit_env && config_option(p, inherit_env))
end

class Trackify
  
  def self.carrier_type(number)
    tracking_service = case number
      when /^.Z/ then :ups
      when /^Q/ then :dhl
      when /^96.{20}$/ then :fedex
      when /^[HK].{10}$/ then :ups
    else
      case number.length
        when 13, 20, 22, 30 then :usps
        when 12, 15, 19 then :fedex
        when 10, 11 then :dhl
        else false
      end
    end
  end
  
  def self.track(number)
    type = carrier_type(number)
    
    case type.to_s
      when 'ups'
        require 'trackify/services/ups'
        Ups.get_response(number)
      when 'dhl'
        require 'trackify/services/dhl'
        Dhl.get_response(number)
      when 'fedex'
        require 'trackify/services/fedex'
        Fedex.get_response(number)
      when 'usps'
        require 'trackify/services/usps'
        Usps.get_response(number)
      end
  end
  
end