# frozen_string_literal: true

module ApplicationHelper
  def format_time(time)
    local_time(time, '%B %e, %Y %l:%M%P %Z')
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def avatar_url(email, size)
    hex = Digest::MD5.hexdigest(email.downcase.strip)
    "https://gravatar.com/avatar/#{hex}?s=#{size}&d=mp"
  end
end
