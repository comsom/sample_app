module ApplicationHelper
  def title
    # Return a title on a per-page basis.
    base_title = 'Ruby on Rails Tutorial; sample_app'
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end
end
