class Purchase 
    include DataMapper::Resource

    property :health_center_id    ,Serial  
    property :cpt_code            ,String       ,length: 0..75
    property :drug_name           ,String       ,length: 0..75
    property :count               ,Integer
    property :date                ,String       ,length: 0..75
end

