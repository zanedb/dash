# frozen_string_literal: true

module ApplicationHelper
  def format_time(time)
    local_time(time, '%B %e, %Y %l:%M%P %Z')
  end

  def title(page_title, append_name = true)
    page_title ||= 'H&M'
    page_title.concat('—H&M') if append_name
    content_for(:title) { page_title }
  end

  def gravatar_url(email, name, size = 48)
    hex = Digest::MD5.hexdigest(email.downcase.strip)
    "https://gravatar.com/avatar/#{hex}?s=#{size}&d=https%3A%2F%2Fui-avatars.com%2Fapi%2F/#{URI.encode(get_initials(name))}/#{size}/97a0ad/fff/2/0.4/false/true"
  end

  def avatar_for(user, size = 48, options = {})
    image = if user.class != Attendee && user&.avatar&.attached?
              user.avatar
            else
              gravatar_url(user.email, user.name, size * 2)
            end
    image_tag image, options.merge(title: user.name, alt: user.name, width: size, height: size, class: "profile-img #{options[:class]}")
  end

  def get_initials(name)
    separated = name.split(' ')
    separated.length == 2 ? "#{separated[0][0].upcase}#{separated[1][0].upcase}" : name
  end

  def user_mention(user)
    avi = avatar_for user
    name = content_tag :span, user.name
    content_tag :span, avi + name, class: 'mention'
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
