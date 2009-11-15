require 'fileutils'

config = File.dirname(__FILE__) + '/../../../config/trackify_config.yml'
FileUtils.cp File.dirname(__FILE__) + '/trackify_config.yml.tpl', config unless File.exist?(config)
puts IO.read(File.join(File.dirname(__FILE__), 'README'))