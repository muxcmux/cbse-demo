class TokensController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  # POST /v1/tokens.json
  def create
    email = params[:email]
    passwd = params[:password]
    
    if email.blank? or passwd.blank?
      render :status => 400, :json => {:message => 'No email or password provided'}
      return
    end
    
    user = User.find_by_email email.downcase
    
    if user.blank?
      render :status => 401, :json => {:message => "Authentication failed. No user found with email: #{email}"}
      return
    end
    
    user.ensure_authentication_token!
    
    unless user.valid_password? passwd
      render :status => 401, :json => {:message => 'Authentication failed. Invalid email/password combination'}
    else
      render :status => 200, :json => {:token => user.authentication_token}
    end
  end
  
  # DELETE /v1/tokens/[token].json
  def destroy
    user = User.find_by_authentication_token params[:id]
    if user.blank?
      render :status => 404, :json =>{:message => 'Invalid token'}
    else
      user.reset_authentication_token!
      render :status => 200, :json => {:token => params[:id]}
    end
  end
  
end