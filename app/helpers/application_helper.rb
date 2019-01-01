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
