# Manager Data Model

class Manager
  include DataMapper::Resource

  property :id          ,Serial
  property :name        ,String       ,length: 0..75
  property :email       ,String       ,length: 0..75
end
