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
  
end
