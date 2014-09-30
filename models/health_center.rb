class HealthCenter
  include DataMapper::Resource

  property :id          ,Serial
  property :name        ,String         ,length: 0..75
  property :manager_id  ,Serial
end
