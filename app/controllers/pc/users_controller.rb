class Pc::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action  :verify_authenticity_token
  
  def create    
    device = "pc"
    user_agent = UserAgent.parse(request.user_agent)
    @user = User.find_or_initialize_by(phone: user_params[:phone])
    @user.assign_attributes(user_params)
    @user.device = device
    @user.source = session[:source]
    Rails.logger.info "@@@session@@@"+session[:source].to_s
    respond_to do |format|
      if @user.save
        coupon = Coupon.new
        coupon.code = coupon.random_code
        coupon.user = @user
        coupon.save
      
        applied_event = AppliedEvent.new
        applied_event.title = @user.event_title
        applied_event.user = @user
        applied_event.device = device
        applied_event.save
        
        @log = AccessLog.new(ip: request.remote_ip, device: device)
        @log.user = @user
        @log.save
      
        format.html { redirect_to pc_index_path, notice: 'User was successfully created.' }
        format.json { render json: {status: "success"}, status: :created   }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def delete
    test_users = [
      "010-6418-4332", "010-2515-4373", "010-9911-1804", 
      "010-2740-7375", "010-7599-0897", "010-4727-1051"
    ]
    @users = User.where(test_users)
    @users.destroy_all
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:event_title, :name, :phone, :agree, :agree_option, :address, :code6, :address_detail, :poster_code)
    end
end
