require './lib/mysql_connection'

class Site
  @instances = {}

  def self.new(id)
    if @instances[id].nil?
      @instances[id] = super
    end

    @instances[id]
  end

  attr_accessor 'coords'

  def initialize(id)
    results = Mysql.query "SELECT * FROM `site` WHERE `SiteId` = '#{id}'"

    if results.count != 1
      raise "Bad site ID #{id}"
    end

    self.coords = gps_to_lat_lng results.first['GPSX'], results.first['GPSY']
  end

  def gps_to_lat_lng(lat, lng)
    [
      (lat * 180.0) / 33554432,
      (lng * 360.0) / 67108864
    ]
  end
end
