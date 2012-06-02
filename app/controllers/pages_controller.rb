class PagesController < ApplicationController
    
  def serve_static_page
    file = File.join(Rails.root, 'app', 'views', 'pages', "#{params[:permalink]}.html.erb")
    raise ActionController::RoutingError.new 404 unless File.exists? file
    render "pages/#{params[:permalink]}"
  end
   
end