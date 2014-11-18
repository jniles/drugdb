require "data_mapper"
require "bcrypt"

# Require configuration file if not defined elsewhere
exists = defined? CONFIG
if exists.nil?
  CONFIG = YAML.load(File.open("config.yaml"))
end

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
