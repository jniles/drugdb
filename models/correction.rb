class Correction 
    include DataMapper::Resource

    property :id                  ,Serial
    property :count               ,Integer
    property :date                ,String       ,length: 0..75

    belongs_to :health_center
    belongs_to :cpt
end

