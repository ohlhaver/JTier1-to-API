class Source < ActiveRecord::Base
  
  attr_accessor :region_id
  
  after_save :reassociate_region
  
  protected
  
  def reassociate_region
    self.regions.delete_all
    region = Region.find_by_id( region_id )
    self.source_regions.create( :region_id => region.id )
    self.regions(true)
  end
  
end
