#Methods that apply to all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery :except => :create

  before_filter :authenticate_user!, :except => [:index, :show] unless Rails.env == 'test'

end
