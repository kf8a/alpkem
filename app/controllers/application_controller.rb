# frozen_string_literal: true

# Methods that apply to all controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user! if Rails.env.production?
end
