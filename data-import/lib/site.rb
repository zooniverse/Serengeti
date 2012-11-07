require 'json'
require_relative 'mysql_connection'
require 'coordinates_transformations'

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

  def gps_to_lat_lng(x, y)
    utm = GeoUtm::UTM.new '36M', x, y
    lat_lng = utm.to_lat_lon
    lat = lat_lng.lat
    lng = lat_lng.lon
    [lat, lng]
  end
end
