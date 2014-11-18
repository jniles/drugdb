require 'yaml'
CONFIG = YAML.load(File.open("config.yaml"))

require './server'
run SST::App
