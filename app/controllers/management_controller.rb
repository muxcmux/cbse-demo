class ManagementController < ApplicationController
  
  layout 'management'
  
  before_filter :authenticate_admin!
  
  def index
    
  end
  
end