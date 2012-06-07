class AtmController < ApplicationController
  
  before_filter :authenticate_user!
  
  layout 'atm'
  
  def index
    
  end
  
end