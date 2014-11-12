class DrugDisplay < Sinatra::Base

	set :views, Dir.pwd + "/views"

	get '/drugs' do
		env['warden'].authenticate!
		cpts = Cpt.all
		@drug_data = [] #this is where we'll put our data
		for cpt in cpts do
			all_counts = Count.all(:cpt => cpt, :order => [:date.asc]).to_a #get all counts associated to this one, for plotting, in descending order
			if all_counts.length > 0
				#now get all sales for this cpt
				puts cpt.code
				puts all_counts[-1].date
				all_sales = Sale.all(:cpt => cpt, :date.gte => all_counts[-1].date, :order => [:date.asc]) #get all sales that are newer than the last count
				for sale in all_sales do
					puts sale.date
				end
				current_count = {:count => all_counts[-1].count,:date => all_counts[-1].date } #this is going to be the one we append to the end of all_counts
				#we set it to the date of the last count until we can prove sales of the stuff
				if not all_sales.nil?
					for sale in all_sales do
						#subtract off the sales so we get an estimate of where we are today
						#TODO: maybe add parlvl stuff here?
						#also add corrections...
							current_count[:count] -= sale.count 
							current_count[:date] = sale.date
					end
				end
				all_counts.push(current_count) #make sure we add this to our chart
			cpt_hash = {:code => cpt.code, :name => cpt.drug.name, :all_counts => all_counts, :current_count => current_count[:count], :vendor => cpt.drug.vendor, :sales => all_sales} #we need to keep all_counts for graphing
			else
				cpt_hash = {:code => cpt.code, :name => cpt.drug.name, :all_counts => nil, :current_count => 0, :vendor => cpt.drug.vendor}
			end
			@drug_data.push(cpt_hash) #put it here so we can iterate through in the template
		end
		erb :test
  end
end
