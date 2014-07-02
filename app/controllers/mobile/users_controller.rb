class Mobile::UsersController < ApplicationController
  layout "mobile"
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action  :verify_authenticity_token
  
  def create
    user_agent = UserAgent.parse(request.user_agent)
    @user = User.new(user_params)
    @user.device = "mobile"
    @user.source = session[:source]
    
    respond_to do |format|
      if @user.save
        @log = AccessLog.new(ip: request.remote_ip, device: "mobile")
        @log.user = @user
        @log.save
      
        applied_event = AppliedEvent.new
        applied_event.title = "poster_event"
        applied_event.user = @user
        applied_event.save
        
        format.html { redirect_to mobile_thanks_path, notice: 'User was successfully created.' }
        format.json { render json: {status: "success"}, status: :created, location: @user }
      else
        format.html {
          flag = "uniqueness"
          flag = "presence" unless @user.errors.values.flatten.index("must be accepted").nil?
          flag = "presence" unless @user.errors.values.flatten.index("can't be blank").nil?
          if flag == "presence"
            render action: 'new' 
          else
            redirect_to mobile_already_path
          end
        }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new
    unless params[:code].nil?
      session[:poster_code] = params[:code]
    end  
    Rails.logger.info("@@@@@@@@@@@@@@@@@@@@@"+session[:poster_code])
    @user = User.new(poster_code: session[:poster_code])

  end
    
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def error_redirect(errors)
    unless errors.get(:phone).index("has already been taken") == nil
      redirect_to mobile_unique_error_path()
    else
      redirect_to action: "new"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user)
      .permit(:name, :phone, :agree, :agree_option, :address, :address_detail, :poster_code, :code6)
  end 
end