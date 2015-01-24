require 'json'

#  Draws the drug charts
class DrugDisplay < Sinatra::Base
  set :views, Dir.pwd + '/views'

  get '/drugs' do
    env['warden'].authenticate!

    # get all health centers
    health_centers = HealthCenter.all
    cpts = Cpt.all

    @hc_data = [] # here's where we store the health center stuff...group by

    health_centers.each do |health_center|
      drug_data = [] # this is where we'll put our data for drugs
      cpts.each do |cpt|
        all_counts = Count.all(cpt: cpt, health_center: health_center, order: [:date.asc]).to_a # get all counts associated to this one, for plotting, in ascending order
        if all_counts.length > 0

          # now get all sales for this cpt
          all_sales = Sale.all(cpt: cpt, :date.gte => all_counts[-1].date, health_center: health_center, order: [:date.asc]) # get all sales that are newer than the last count
          all_purchases = Purchase.all(cpt: cpt, :date.gte => all_counts[-1].date, health_center: health_center, order: [:date.asc])
          current_count = { count: all_counts[-1].count,date: all_counts[-1].date } # this is going to be the one we append to the end of all_counts
          all_corrections = Correction.all(cpt: cpt, :date.gte => all_counts[-1].date, health_center: health_center, order: [:date.asc])

          # We set it to the date of the last count
          # until we can prove sales of the stuff
          unless all_sales.nil?
            all_sales.each do |sale|

              # Subtract off the sales so we get an estimate of where we are today
              # TODO: maybe add parlvl stuff here?
              # also add corrections...
              current_count[:count] -= sale.count
              current_count[:date] = sale.date
            end
          end

          unless all_purchases.nil?
            all_purchases.each do |purchase|
              current_count[:count] += purchase.count
              current_count[:date] = purchase.date
            end
          end

          # FIXME
          # Is this check really necessary?  We can just initialize
          # all_corrections to be an empty array if it is nil.  Then
          # the .each {} loop will work!
          unless all_corrections.nil?
            all_corrections.each do |corr|
              # it's negative if it's removing
              current_count[:count] += corr.count
              current_count[:date] = corr.date
            end
          end

          cpt_hash = {
            code: cpt.code,
            name: cpt.drug.name,
            current_count: current_count[:count],
            vendor: cpt.drug.vendor
          }

        else
          cpt_hash = {
            code: cpt.code,
            name: cpt.drug.name,
            current_count: 0,
            vendor: cpt.drug.vendor
          }
        end
        drug_data.push(cpt_hash) # put it here so we can iterate through in the template
      end
      @hc_data.push({ center_name: health_center.name, drugs: drug_data })
    end

    # render the drug report
    erb :drugs
  end

  get '/data/sales/:health_center/:cpt' do
    env['warden'].authenticate!

    health_center = HealthCenter.all(name: params[:health_center])
    cpt = Cpt.all(code: params[:cpt])
    all_sales = Sale.all(cpt: cpt, health_center: health_center, order: [:date.asc]).to_a # get all sales

    # now make stuff
    drug_data = { count: all_sales.map { |x| x.count }, date: all_sales.map { |x| x.date.strftime('%b %d %Y') } }

    # ship back as JSON
    content_type :json
    drug_data.to_json
  end
end
