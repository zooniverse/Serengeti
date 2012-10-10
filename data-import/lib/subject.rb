require './lib/site'

class Subject
  attr_accessor 'site', 'location', 'coords', 'metadata'

  def initialize(record, roll_id, site_id)
    self.site = Site.new(site_id)

    self.location = {record['DateTime'] => record['Filename']}
    self.coords = site.coords

    self.metadata = {
      :roll_id => roll_id
    }
  end
end
