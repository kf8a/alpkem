class UserSessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    logger.info @user_session
    @user_session.save do |result|
      if result
        flash[:notice] = "Login successful!"
        redirect_back_or_default '/runs'
      else
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_sessions_url
  end

end
