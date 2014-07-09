class AddressesController < ApplicationController
  
  def index
    @addresses = Address.where(addr3: params[:q])
    respond_to do |format|
      format.json { render json: @addresses}
    end
    
  end
  
    
end
