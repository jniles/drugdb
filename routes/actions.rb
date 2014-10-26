require_relative '../parsers/xlsparser.rb'

class Actions < Sinatra::Base

  # The shared directory where data is dumped every
  # evening.  This process is either manual or automated
  # but produces a dated subdirectory within this folder.
  # Note: Root is the application root.
  shareDir = "data/"

  def exists(path)
    return File.exists?(path)
  end

  # Parse the worksheet "Inventory Counts.xls"
  # Create new purchase rows for each record
  # found in the sheet.
  def parseInventory(path, centers)
    sheet = "Inventory Counts.xls"
    puts "Does #{path}#{sheet} exist? #{exists(path+sheet)}"
    if exists(path+sheet)
      centers.each do |center|
        parser = XLSParser.new(path+sheet, center.name)
        parser.read().each do |row|
          cpt = Drug.get(row[2]) # get the drug from the cpt code
          if cpt.nil?
            #puts "CPT is nil for row #{row}"
          end
          Purchase.create({:cpt => cpt, :count => row[3], :date => row[4], :health_center => center})
        end
      end
    end
  end

  def parsePurchase(path, centers)
    #sheet = "Purchase Log.xls"
  end

  def parseSales(path, centers)
    #sheet = "Sales.xls"
  end

  # Parse up to a particular timestamp
  get '/parse/:timestamp' do
    timestamp = params[:timestamp]

    # We want to scan the file system everytime
    # this path gets hit, in case things have
    # changed since last time.
    dirs = Dir.glob("#{shareDir}[0-9]*")

    puts "dirs is #{dirs}"

    # Parse only the latest file if keyword
    # latest is triggered
    if timestamp == 'latest'
      puts "Parsing lastest timestamp."
      folder = dirs.max
    else
      puts "Parsing this timestamp #{timestamp}."
      if dirs.count(shareDir+timestamp) < 1
        raise "Could not find directory #{shareDir}#{timestamp}"
      else
        folder = timestamp
      end
    end

    # add trailing slash
    folder = shareDir + folder + '/'

    puts "Parsing folder #{folder}"

    # Get all health centers, to select which sheet name
    # to use.
    centers = HealthCenter.all

    # parse the inventory
    parseInventory(folder, centers)
  end

end
