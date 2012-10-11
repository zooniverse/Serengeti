require './lib/mysql_connection'
require './lib/site'
require 'json'

def q(str)
  "'#{str.sub "'", "\\\\'"}'"
end

class Subject
  attr_accessor 'site', 'location', 'coords', 'metadata'

  def initialize(record, image_path)
    self.site = Site.new(record['SiteCode'])

    self.location = {record['DateTime'] => image_path}
    self.coords = site.coords

    self.metadata = {}
    record.each do |property, value|
      self.metadata[property] = value
    end
  end

  def save
    data = {
      :location => q(JSON.dump(self.location.values)),
      :coords => q(JSON.dump(self.coords)),
      :metadata => q(JSON.dump(self.metadata)),
      :created => 0,
      :uploaded => 0
    }

    Mysql.query "INSERT INTO zooniverse_subjects (#{data.keys.join ','}) VALUES (#{data.values.join ','})"
  end
end
