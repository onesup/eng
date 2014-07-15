class User < ActiveRecord::Base
  devise :database_authenticatable
  
  has_many :applied_events
  has_many :messages
  has_many :access_logs
  has_one :coupon
  has_many :comments
  
  before_validation :apply_poster_event?
  validates :code6, presence: true, if: :poster_event?
  validates :address, presence: true, if: :poster_event?
  validates :agree, acceptance: true
  # validates :agree2, acceptance: true
  validates :name, presence: true
  validates :phone, presence: true
  #validates :phone, uniqueness: true

  attr_accessor :agree, :agree2
  attr_accessor :event_title
  
  def self.poster_stock(poster_code)
    days_of_week = if DateTime.parse("2014-07-04").beginning_of_day <= Time.now && Time.now <= DateTime.parse("2014-07-13 23:59:59 +0900")
      DateTime.parse("2014-07-04 00:00:00 +0900")..DateTime.parse("2014-07-13 23:59:59 +0900")
    elsif DateTime.parse("2014-07-14 00:00:00 +0900") <= Time.now && Time.now <= DateTime.parse("2014-07-20 23:59:59 +0900")
      DateTime.parse("2014-07-14 00:00:00 +0900")..DateTime.parse("2014-07-20 23:59:59 +0900")
    elsif DateTime.parse("2014-07-21 00:00:00 +0900") <= Time.now && Time.now <= DateTime.parse("2014-07-27 23:59:59 +0900")
      DateTime.parse("2014-07-21 00:00:00 +0900")..DateTime.parse("2014-07-27 23:59:59 +0900")
    elsif DateTime.parse("2014-07-28 00:00:00 +0900") <= Time.now && Time.now <= DateTime.parse("2014-08-03 23:59:59 +0900")
      DateTime.parse("2014-07-28 00:00:00 +0900")..DateTime.parse("2014-08-03 23:59:59 +0900")
    elsif DateTime.parse("2014-08-04 00:00:00 +0900") <= Time.now && Time.now <= DateTime.parse("2014-08-10 23:59:59 +0900")
      DateTime.parse("2014-08-04 00:00:00 +0900")..DateTime.parse("2014-08-10 23:59:59 +0900")
    else
      DateTime.parse("2013-07-04")..DateTime.parse("2013-07-13")
    end
    puts "@@@@@"
    puts days_of_week
    puts "@@@@@@"
    return 300 - self.where(poster_code: poster_code, created_at:(days_of_week)).count
  end
  def apply_poster_event? 
    user = User.find_by_phone(self.phone)
    user = User.new if user.nil?
    result = true
    if self.event_title == "poster"
      result = false if user.applied_events.where(title: "poster").exists?
    elsif self.event_title == "comment"
      result = false if user.applied_events.where(title: "comment").exists?
    end
    return result
  end
  
  def poster_event?
    self.event_title == "poster"
  end

  def send_survey
    Message.send_survey_to(self)
  end
  
  def send_120_survey(phone)
    Message.send_120_survey_to(phone)
  end
    
  def self.convert_phone(phone)
    phone = phone.insert(3, "-").insert(8, "-")
  end
  
  def self.send_survey_message
    offset_start = 1
    finish = all.count
    until offset_start > finish
      all.limit(100).offset(offset_start).each do |u|
        puts u.name
        u.send_survey
      end
      offset_start = offset_start + 100
    end
  end
  
  def self.coupon_used_counts
    result = User.select("
      date(convert_tz(coupons.updated_at,'+00:00','+09:00')) used_date,
      count(*) used_count")
      .joins(:coupon)
      .where(coupons: {status: "used"})
      .group("date(convert_tz(coupons.updated_at,'+00:00','+09:00'))")
      .order("coupons.updated_at")
  end
  
  def self.coupon_used_users
    result = User.includes(:coupon)
      .where(coupons: {status: "used"})
      .order("coupons.updated_at DESC")
  end
  
  def self.count_by_device_type(event_title)
    result = self.select(
      
      "sum(case when users.device = 'pc' then 1 else 0 end) as pc_count, 
      sum(case when users.device = 'mobile' then 1 else 0 end) as mobile_count, 
      count(*) as total_count")
  end
  
  def self.user_120
    phones = Array.new
    User.where(phone: User.coupon_users).each do |user|
      phones << user.phone
    end
    user_120 = User.coupon_users - phones
  end
  
  def self.coupon_users
    ['010-8812-5111']
  end
  
  def self.first_day()
    self.select("created_at").order("created_at").limit(1) 
  end
  
  
  def self.paginate_by_week(page)
    page ||= 1 
    page = page.to_i
    start_date = (DateTime.now-DateTime.now.wday-7*(page-1)).beginning_of_day
    end_date = (DateTime.now+(7-DateTime.now.wday)-7*(page-1)).beginning_of_day
    self.source_by_weekday(start_date,end_date)
  end
  
  def self.source_by_weekday(start_date, end_date)
    self.select("source
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 1 then 1 else 0 end) as 'sun'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 2 then 1 else 0 end) as 'mon'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 3 then 1 else 0 end) as 'tue'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 4 then 1 else 0 end) as 'wed'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 5 then 1 else 0 end) as 'thu'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 6 then 1 else 0 end) as 'fri'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 7 then 1 else 0 end) as 'sat' ")
        .where("created_at >= ? and created_at < ?", start_date, end_date)
        .group("source").order("source")
  end
  
  def self.paginate_by_week_sum(page)
    page ||= 1 
    page = page.to_i
    start_date = (DateTime.now-DateTime.now.wday-7*(page-1)).beginning_of_day
    end_date = (DateTime.now+(7-DateTime.now.wday)-7*(page-1)).beginning_of_day
    self.source_by_weekday_sum(start_date,end_date)
  end
  
  def self.source_by_weekday_sum(start_date,end_date)
    self.select(
      "sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 1 then 1 else 0 end) as 'sun'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 2 then 1 else 0 end) as 'mon'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 3 then 1 else 0 end) as 'tue'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 4 then 1 else 0 end) as 'wed'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 5 then 1 else 0 end) as 'thu'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 6 then 1 else 0 end) as 'fri'
      ,sum(case when DayofWeek(convert_tz(created_at,'+00:00','+09:00')) = 7 then 1 else 0 end) as 'sat' ")
        .where("created_at >= ? and created_at < ?", start_date, end_date)
  end
  
end
