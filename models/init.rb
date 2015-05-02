require "sequel"

# Require configuration file if not defined elsewhere
exists = defined? CONFIG
if exists.nil?
  CONFIG = YAML.load(File.open("config.yaml"))
end

def setup(cfg)

  # Get the database URI and connect
  uri = "#{File.join(cfg["install_dir"], "db", "drug.db")}"
  puts uri

  # connect to database
  Sequel.sqlite(uri)
end

# run setup
setup CONFIG

# class Cpt
#   include DataMapper::Resource
#
#   property :code            ,String         ,:key => true
#
#   belongs_to :drug
#
#   has n, :sales
#   has n, :purchases
#   has n, :counts
#   has n, :corrections
# end
class Cpt < Sequel::Model(:cpt)
end

# class Drug
#   include DataMapper::Resource
#
#   property :id              ,Serial
#   property :name            ,String         ,length: 0..75
#   property :barcode         ,Integer
#   property :vendor          ,String         ,length: 0..75
#
#   has n, :cpts
# end
class Drug < Sequel::Model(:drug)
end

# class Sale
#   include DataMapper::Resource
#
#   property :count               ,Integer      ,:key => true
#   property :date                ,Date         ,:key => true
#   belongs_to :health_center     ,:key => true
#   belongs_to :cpt               ,:key => true
# end
class Sale < Sequel::Model(:sale)
end

# class Purchase 
#     include DataMapper::Resource
# 
#     property :count               ,Integer      ,:key => true
#     property :date                ,Date         ,:key => true
# 
#     belongs_to :health_center, key: true
#     belongs_to :cpt, key: true
# end
class Purchase < Sequel::Model(:purchase)
end

# class Count
#     include DataMapper::Resource
#
#     property :count               ,Integer      ,:key => true
#     property :date                ,Date         ,:key => true
#     belongs_to :health_center     ,:key => true
#     belongs_to :cpt               ,:key => true
# end
class Count < Sequel::Model(:count)
end

# class Correction
#     include DataMapper::Resource
#
#     property :count               ,Integer      ,:key => true
#     property :date                ,Date         ,:key => true
#
#     belongs_to :health_center, key: true
#     belongs_to :cpt, key: true
# end
class Correction < Sequel::Model(:correction)
end

# class LastDate
# 	include DataMapper::Resource
#
# 	property :id             ,Serial
# 	property :last_update    ,Date
# end
class LastDate < Sequel::Model(:last_date)
end

# class HealthCenter
#   include DataMapper::Resource
#
#   property :id          ,Serial
#   property :name        ,String         ,length: 0..75
#
#   belongs_to :manager
#
#   has n, :sales
#   has n, :purchases
#   has n, :corrections
#   has n, :counts
# end
class HealthCenter < Sequel::Model(:health_center)
end

# class Manager
#   include DataMapper::Resource
#
#   property :id          ,Serial
#   property :name        ,String       ,length: 0..75
#   property :email       ,String       ,length: 0..75
#
#   has n, :health_centers
# end
class Manager < Sequel::Model(:manager)
end

# class User
#   include DataMapper::Resource
#   include BCrypt
# 
#   before :save, :generate_token
#   before :create, :generate_token
# 
#   property :id            ,Serial         
#   property :name          ,String         ,length: 0..75
#   property :email         ,String         ,length: 0..75
#   property :password      ,BCryptHash
#   property :token         ,String         ,length: 0..100
#   property :created       ,DateTime
#   property :updated       ,DateTime
#   property :active        ,Integer        ,default: 0
#   property :uuid_token    ,String         ,length: 36 #exactly 36. UUIDs always the same size
#   property :uuid_date     ,Date
# 
#   # methods
#   def generate_token
#     self.token = BCrypt::Engine.generate_salt if self.token.nil?
#   end
# 
#   def authenticate(pass)
#     self.password == pass
#   end
# end
class User < Sequel::Model(:users)

  def authenticate(pass)
    self.password == pass
  end

  def generate_token
    self.token = BCrypt::Engine.generate_salt if self.token.nil?
  end
end
