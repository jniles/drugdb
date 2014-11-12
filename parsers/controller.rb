# /parsers/controller.rb
#
# This module is responsible for higher-level db parsing
# functions, such a building the initial install or
# rebuilding the old database.

require 'spreadsheet'

CONFIG = YAML.load(File.open("config.yaml"))

# TODO
#   Replace this class with a simple function, that reads
#   data using the RubyXL gem from *.xlsx files.  This will
#   eliminate our dependency on the spreadsheet gem.
class XLSParser

  # DEPRECATED but necessary

  def initialize(xlspath, sheet)
    @book = Spreadsheet.open xlspath
    @sheet = @book.worksheet sheet
  end

  def read(skip=3)
    rows = []
    breaks = 0
    maxBreaks = 4
    @sheet.each skip do |row| # omit header rows, start at `skip` row
      if row.any?
        rows << row
      else
        puts "[PARSER::WARNING] Omitting empty row."
        breaks += 1
      end
      if maxBreaks < breaks # Prevent reading 1000+ empty lines.  Break after maxBreaks empty rows have been reached.
        break
      end
    end
    return rows
  end
end

# TODO
#   Find a better name for this. Ugh.  Everything is terrible.
class Controller

  def self.rebuild(opts)
    # Rebuild the database by dropping all data in each table,
    # then rebuilding using /init folder in the data directory.
    if not File.exists?(opts.db)
      raise "ERROR: Database file not defined.  Please run 'parser/main.rb --install' to setup the database."
    end

    puts "Rebuilding database."

    # Drop values in each database table
    Sale.destroy
    Count.destroy
    Purchase.destroy
    Correction.destroy
    Cpt.destroy
    Drug.destroy
    HealthCenter.destroy
    Manager.destroy
    User.destroy

    # The database is now wiped clean.  Let's import the fresh data
    # from the {data_path}/init directory

    path = opts.data_path + "init/"

    # populate table `users`
    uparser = XLSParser.new(path+"user.xls", "user")
    uparser.read(1).each do |row|
      User.create(:id => row[0], :name => row[1], :email => row[2], :password => row[3], :created => Time.now)
    end

    # populate table `managers`
    mparser = XLSParser.new(path+"manager.xls", "manager")
    mparser.read(1).each do |row|
      Manager.create(:id => row[0], :name => row[1], :email=> row[2])
    end

    # populate table `health_centers`
    hparser = XLSParser.new(path+"health_center.xls", "health_center")
    hparser.read(1).each do |row|
      manager = Manager.get(row[2])
      HealthCenter.create(:id => row[0], :name => row[1], :manager => manager)
    end

    # populate tables `cpt` and `drugs`
    dparser = XLSParser.new(path+"drug.xls", "drug")
    dparser.read(1).each do |row|
      drug = Drug.create(:name => row[1])
      Cpt.create(:code => row[0], :drug => drug)
    end

    # We now have all the init data and can exit gracefully.
    puts "Loaded data from #{path}."
  end

  def self.disconnect!
    # Disconnect datamapper from all databases to ensure
    # system integrity
    DataObjects::Pooling.pools.each do |pool|
      pool.dispose
    end
  end

  def self.reconnect!(path)
    # Reconnect datamapper to an sqlite database instance
    url = "sqlite://#{path}"
    DataMapper.setup :default, url
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  def self.install(opts)
    # Creates a fresh drug inventory database,
    # removing the old one if it exits.

    # First, we disconnect the existing database connection
    self.disconnect!

    # Delete the database file
    if File.exists?(opts.db)
      File.delete(opts.db)
    end

    # Now, we load the schema file and create the database
    res = system("sqlite3 #{opts.db} < #{opts.schema}")

    if not res
      raise "An error occurred during system creation of the database."
    end

    # We can reconnect the database now
    self.reconnect!(opts.db)

    # Finally, build the basic initialization data
    self.rebuild(opts)
  end
end
