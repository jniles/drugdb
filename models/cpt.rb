class Cpt
  include DataMapper::Resource

  property :id              ,Serial
  property :code            ,String         ,:key => true

  belongs_to :drug

  has n, :sales
  has n, :purchases
  has n, :counts
  has n, :corrections
end
