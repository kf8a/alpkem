# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def showing_progress(opts={})
    opts.merge :loading  => update_page{|p| p[:spinner].show },
               :complete => update_page{|p| p[:spinner].hide }
  end
  
end
