#Methods that apply to all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_filter :verify_authenticity_token, :if => :json_request?

  before_filter :authenticate_user!, :except => [:index, :show] unless Rails.env == 'test'

end
