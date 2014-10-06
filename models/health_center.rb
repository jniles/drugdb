class HealthCenter
  include DataMapper::Resource

  property :id          ,Serial
  property :name        ,String         ,length: 0..75

  belongs_to :manager

  has n, :sales
  has n, :purchases
  has n, :corrections
  has n, :counts
end
