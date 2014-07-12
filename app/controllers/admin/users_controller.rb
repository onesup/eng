class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  def index
    @users = User.includes(:access_logs, :applied_events)
    @users = @users.where('applied_events.title' => "poster").order("users.poster_code asc, users.code6 asc").page(params[:page]).per(200)
    @user_counts = AppliedEvent.count_by_device_type("poster")
  end
  
  def before_users
    @users = User.where(created_at: [Date.parse('2014-06-30').beginning_of_day..Date.parse('2014-06-30').end_of_day]).page(params[:page]).per(200)
  end
  
  def comment_users
    @users = User.includes(:access_logs, :applied_events)
    @users = @users.where('applied_events.title' => "comment").order("users.id desc").page(params[:page]).per(200)
    @user_counts = AppliedEvent.count_by_device_type("comment")
  end
  
  def couponused
    @coupon_used_users = User.coupon_used_users.page(params[:page]).per(200)
    @coupon_used_counts = User.coupon_used_counts
  end
  
  def logs
    id = params[:id]
    id = 1 if id.nil?
    @user_stats = User.paginate_by_week(id)
    @user_stats_sum = User.paginate_by_week_sum(id)
    @user_first_day = User.first_day()
  end
  
end
