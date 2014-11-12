require "data_mapper"
require "bcrypt"

# Require configuration file.
# FIXME : This needs to be global for both the cmd line
# context (./parsers/main.rb) and the server context (./server.rb)
CONFIG = YAML.load(File.open("config.yaml"))

def setup(cfg)

  # Sanitity check
  if not cfg['db']
    raise "ERROR: No database specified in config.yaml file.  Please specify a database."
  end

  # Get the database URI and connect
  url = "sqlite://#{cfg['db']}"
  DataMapper.setup :default, url

  require "./models/user"
  require "./models/manager"
  require "./models/health_center"
  require "./models/drug"
  require "./models/cpt"
  require "./models/correction"
  require "./models/count"
  require "./models/purchase"
  require "./models/sale"

  DataMapper.finalize
  DataMapper.auto_upgrade!
end

setup CONFIG
