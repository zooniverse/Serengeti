require 'json'
require_relative 'mysql_connection'
require_relative 'site'
require_relative 'q'

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

    self.metadata['capture_times'] = self.location.keys
  end

  def save
    data = {
      :local_location => q(JSON.dump(self.location.values)),
      :coords => q(JSON.dump(self.coords)),
      :metadata => q(JSON.dump(self.metadata))
    }

    Mysql.query "INSERT INTO zooniverse_subjects (#{data.keys.join ','}) VALUES (#{data.values.join ','})"
  end
end
