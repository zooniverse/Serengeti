require './lib/mysql_connection'
require 'json'

class Site
  @instances = {}

  def self.new(id)
    if @instances[id].nil?
      @instances[id] = super
    end

    @instances[id]
  end

  attr_accessor 'coords', 'metadata'

  def initialize(id)
    site_record = Mysql.query("SELECT * FROM site WHERE SiteId = '#{id}'").first
    raise "Bad site ID: #{id}" if site_record.nil?

    self.coords = gps_to_lat_lng site_record['GPSX'], site_record['GPSY']

    self.metadata = {}
    site_record.each do |property, value|
      self.metadata[property] = value
    end
  end

  def gps_to_lat_lng(lat, lng)
    # Via http://www.gps-forums.net/strange-coordinates-t35858.html
    [(lat * 180.0) / 33554432, (lng * 360.0) / 67108864]
  end
end
