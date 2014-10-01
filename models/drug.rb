class Drug
  include DataMapper::Resource

  property :id              ,Serial
  property :cpt_code        ,String         ,length: 0..75
  property :name            ,String         ,length: 0..75
  property :bar_code        ,Integer
  property :vendor          ,String         ,length: 0..75
end
