class CommentsController < ApplicationController

  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  skip_before_action  :verify_authenticity_token
 
  def create
    Rails.logger.info("@@@@@@@@@@@@@@@@@@"+params[:user_phone]) 
    Rails.logger.info(User.find_by_phone(params[:user_phone]).name)
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to pc_index_path, notice: 'Comment was successfully created.' }
        format.json { render json: {status: "success"}, status: :created   }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end
    
end
