class AppliedEvent < ActiveRecord::Base
  belongs_to :user


  def self.count_by_device_type(event_title)
    result = self.select(      
      "sum(case when applied_events.title = '"+event_title+"' and applied_events.device = 'pc' then 1 else 0 end) as pc_count, 
      sum(case when applied_events.title = '"+event_title+"' and applied_events.device = 'mobile' then 1 else 0 end) as mobile_count, 
      sum(case when applied_events.title = '"+event_title+"' then 1 else 0 end) as total_count")
  end
  
end