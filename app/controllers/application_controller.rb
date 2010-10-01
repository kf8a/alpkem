# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
 # helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :require_user, :except => [:index, :show] if ::RAILS_ENV == 'production'
  helper_method :current_user_session, :current_user

  private
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_sessions_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def runs
    all_runs = Run.find(:all, :order => 'sample_date')
    runs_index = []
    all_runs.each do |run|
      runs_index << run unless run.cn_measurements_exist?
    end
    runs_index
  end

  def cn_runs
    all_runs = Run.find(:all, :order => 'sample_date')
    runs_index = []
    all_runs.each do |run|
      runs_index << run if run.cn_measurements_exist?
    end
    runs_index
  end

end
