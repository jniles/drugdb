require 'json'

class DrugDisplay < Sinatra::Base
	set :views, Dir.pwd + "/views"

	get '/drugs' do
		env['warden'].authenticate!
		health_centers = HealthCenter.all
		cpts = Cpt.all
		@hc_data = [] #here's where we store the health center stuff...group by
		for health_center in health_centers do
			drug_data = [] #this is where we'll put our data for drugs
			count_data = [] #this is where we'll put count stuff for all drugs - we already calculate the stock levels, let's not work twice for no good reason
			for cpt in cpts do
				all_counts = Count.all(:cpt => cpt, :health_center => health_center, :order => [:date.asc]).to_a #get all counts associated to this one, for plotting, in ascending order
				if all_counts.length > 0
					#now get all sales for this cpt
					all_sales = Sale.all(:cpt => cpt, :date.gte => all_counts[-1].date, :health_center => health_center, :order => [:date.asc]) #get all sales that are newer than the last count
					all_purchases = Purchase.all(:cpt => cpt, :date.gte => all_counts[-1].date, :health_center => health_center, :order => [:date.asc])
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
					if not all_purchases.nil?
						for purchase in all_purchases do
							current_count[:count] += purchase.count
							current_count[:date] = purchase.date
						end
					end
					all_counts.push(current_count) #make sure we add this to our chart
					count_data.push({'counts' => all_counts, 'drug' => cpt.code})
				cpt_hash = {:code => cpt.code, :name => cpt.drug.name, :current_count => current_count[:count], :vendor => cpt.drug.vendor, :sales => all_sales} #we need to keep all_counts for graphing
				else
					cpt_hash = {:code => cpt.code, :name => cpt.drug.name, :current_count => 0, :vendor => cpt.drug.vendor}
					count_data.push({'counts' => -1, 'drug' => cpt.code})
				end
				drug_data.push(cpt_hash) #put it here so we can iterate through in the template
			end
			@hc_data.push({:center_name => health_center.name, :drugs => drug_data, :counts => count_data.to_json})
		end
		erb :test
  end

	get '/data/sales/:health_center/:cpt' do
		env['warden'].authenticate! #HIPAA means we can't just let this get through...
		health_center = HealthCenter.all(:name => params[:health_center])
		cpt = Cpt.all(:code => params[:cpt])
		all_sales = Sale.all(:cpt => cpt, :health_center => health_center, :order => [:date.asc]).to_a #get all sales
		#now make stuff
		drug_data = {'count' => all_sales.map {|x| x.count}, 'date' => all_sales.map {|x| x.date}}
#		drug_data = []
#		for sale in all_sales do
#			drug_data.push([sale.date,sale.count])
#					end
		content_type :json
		drug_data.to_json
	end
end
