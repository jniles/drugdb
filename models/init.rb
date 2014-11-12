require "data_mapper"
require "bcrypt"

CONFIG = YAML.load(File.open("config.yaml"))

def setup(cfg)

  # Sanitity check
  if not cfg['db']
    raise "ERROR: No database specified in config.yaml file.  Please specify a database."
  end

  # Get the database URI and connect
  url = "sqlite://#{cfg['db']}"
  DataMapper.setup :default, url
  DataMapper.finalize
  DataMapper.auto_upgrade!

  require "./models/user"
  require "./models/manager"
  require "./models/health_center"
  require "./models/drug"
  require "./models/cpt"
  require "./models/correction"
  require "./models/count"
  require "./models/purchase"
  require "./models/sale"
end

setup CONFIG
