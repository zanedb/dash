module ApplicationHelper
  def format_time time
    local_time(time, '%B %e, %Y %l:%M%P %Z')
  end
end
