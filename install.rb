require 'ftools'

puts IO.read(File.join(File.dirname(__FILE__), 'README'))

dest_config_file = File.expand_path("#{File.dirname(__FILE__)}/../../../config/omniture.yml")
src_config_file = "#{File.dirname(__FILE__)}/omniture.yml"

unless File::exists? dest_config_file
  yaml = eval "%Q[#{File.read(src_config_file)}]"
  
  File.open( dest_config_file, 'w' ) do |out|
    out.puts yaml
  end
  
  puts "\nInstalling a default configuration file."
  puts "See #{dest_config_file}"
end  
