class AddressesController < ApplicationController
  
  def index
    @addresses = Address.where("addr3 LIKE ? ", "%"+params[:q]+"%").order("zip asc")   
  end
  
    
end
