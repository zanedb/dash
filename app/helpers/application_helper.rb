# frozen_string_literal: true

module ApplicationHelper
  def format_time(time)
    local_time(time, '%B %e, %Y %l:%M%P %Z')
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def avatar_url(user, size = 48)
    if user.avatar.attached?
      user.avatar.variant(resize: "#{size}x#{size}!").processed.service_url
    else
      gravatar_url user.email, size
    end
  end

  def gravatar_url(email, size = 48)
    hex = Digest::MD5.hexdigest(email.downcase.strip)
    "https://gravatar.com/avatar/#{hex}?s=#{size}&d=mp"
  end

  def inline_svg(filename, options = {})
    file = File.read(Rails.root.join('app', 'assets', 'images', 'icons', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    options[:style] ||= ''
    if options[:size]
      options[:width] = options[:size]
      options[:height] = options[:size]
      options.delete :size
    end
    options.each { |key, value| svg[key.to_s] = value }
    doc.to_html.html_safe
  end
end
