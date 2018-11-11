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

  def custom_field(field, form = nil, value = nil)
    if form && field && value
      if field.kind == 'text'
        form.text_field field.name, value: value
      elsif field.kind == 'multiline'
        form.text_area field.name, value: value
      end
    elsif field
      if field.kind == 'text'
        text_field_tag(nil)
      elsif field.kind == 'multiline'
        text_area_tag(nil)
      end
    end
  end
end
