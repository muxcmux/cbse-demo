module ApplicationHelper
  
  def sidebar_link title, link, options = {}
    
    active = false
    
    if options[:c].present? && options[:a].present?
      if options[:c].to_sym == controller_name.to_sym
        if options[:a].to_sym == action_name.to_sym
          active = true
        end
      end
    end
    
    icon = ''
    klass = ''
    
    if active
      klass = 'active'
      if options[:icon]
        icon = "<i class='icon-#{options[:icon]} icon-white'></i>"
      end
    else 
      if options[:icon]
        icon = "<i class=icon-#{options[:icon]}></i>"
      end
    end
    
    title = icon.blank? ? title : "#{icon} #{title}".html_safe
    
    content_tag(:li, link_to(title, link, options), class: klass)
    
  end
  
  def pretty_date date
    return date if date.is_a? String
    date.strftime '%d %B, %Y @ %H:%I:%S'
  end
  
  def header_with_search title
    "<div class=\"row\">
      <h1 class=\"span6\">#{title}</h1>
      <form action=\"\" method=\"get\" class=\"form-search span3\">
        <input type=\"text\" name=\"q\" value=\"#{params[:q]}\" class=\"input-medium search-query\">
        <button type=\"submit\" class=\"btn\">Search</button>
      </form>
    </div>".html_safe
  end
  
  
  def number_to_money n
    number_to_currency n, unit: '&pound;', format: '%u %n', negative_format: '<span class=red>%u -%n</span>'
  end
  
end
