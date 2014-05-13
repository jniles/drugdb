class DrugsPerLoc < ActiveRecord::Base
  self.primary_key = 'Ctr_loc'

  scope :alerts, conditions: {Flag: true}

  #CREATE TABLE  DRUG_PER_LOC (
  #      Ctr_loc         VARCHAR(50)             NOT NULL,
  #      Dname           VARCHAR(50)             NOT NULL,
  #      Par_lvl         INT                             DEFAULT 30,
  #      Flag            CHAR(5)                 DEFAULT FALSE,
  #      PRIMARY KEY (Ctr_loc, Dname),
  #      FOREIGN KEY (Ctr_loc) REFERENCES DIST_CTR (Location)
  #              ON DELETE CASCADE       ON UPDATE CASCADE,
  #      FOREIGN KEY (Dname) REFERENCES DRUG (Dname)
  #              ON DELETE CASCADE       ON UPDATE CASCADE)
  #  DEFAULT CHARACTER SET utf8;

  # has yet to be implemented
  def status
    self.Flag ? 'Good' : 'Low'
  end

  # has yet to be implemented
  def count
    40
  end

  # has yet to be implemented, will it ever be?
  def expiration_date
    Date.tomorrow
  end

end