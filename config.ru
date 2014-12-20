require 'yaml'
CONFIG = YAML.load(File.open(File.dirname(__FILE__) + "/config.yaml"))

require File.dirname(__FILE__) + '/server'
run SST::App
