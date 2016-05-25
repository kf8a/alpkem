# Methods that apply to all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, except: [:index, :show] if Rails.env == 'production'
end
