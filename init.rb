require 'yaml'
require 'omniture'

def to_stderr(s)
  STDERR.puts "** [Omniture] " + s
end

# Initializer for Omniture
config_filename = File.join(File.dirname(__FILE__), '..','..','..','config','omni.yml')

begin
  omniture_config_file = File.read(config_filename)
rescue => e
  to_stderr e
  to_stderr "Could not read configuration file #{config_filename}."
  to_stderr "Be sure to put omni.yml into your config directory."
  to_stderr "Agent is disabled."
  throw :disabled
end

begin
  omniture_config = YAML.load(omniture_config_file) || {}
rescue Exception => e
  to_stderr "Error parsing #{config_filename}"
  to_stderr "#{e}"
  throw :disabled
end

omniture_config.freeze
to_stderr"EVARS!!!"
omniture_config['evars'].each_pair do | key, value|
  to_stderr "#{key} #{value}"
end
to_stderr"EVENTS!!!!"
omniture_config['events'].each_pair do | key, value|
  to_stderr "#{key} #{value}"
end

::EVARS = omniture_config['evars']
::EVENTS = omniture_config['events']
::PROPS = omniture_config['props']