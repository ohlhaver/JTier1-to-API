# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
  
  def render_head_ok_if_exists?( model, id, options = {} )
    conditions = options[:field] ? { options[:field] => id } : id
    if model.exists?( conditions  )
      respond_to do | format |
        format.xml { head :ok }
      end
      return true
    end
    return false
  end
  
end
