class Comment < ActiveRecord::Base
  belongs_to :user
  
  def find_or_create_user(user_phone)
    unless User.find_by_phone(user_phone).nil?
      user = User.find_by_phone(user_phone)
      self.user = user
      self.save
    else
      # new user (전화번호, 주소 공란으로 같이 저장)
    end
  end
  
  
end


