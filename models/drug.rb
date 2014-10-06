class Drug
  include DataMapper::Resource

  property :id              ,Serial
  property :name            ,String         ,length: 0..75
  property :barcode         ,Integer
  property :vendor          ,String         ,length: 0..75

  has n, :cpts
end
