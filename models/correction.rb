class Correction 
    include DataMapper::Resource

    property :count               ,Integer      ,:key => true
    property :date                ,Date         ,:key => true

    belongs_to :health_center, key: true
    belongs_to :cpt, key: true
end

