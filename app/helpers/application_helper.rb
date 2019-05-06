# frozen_string_literal: true

module ApplicationHelper
  def page_md
    content_for(:container_class) { 'container--md' }
  end

  def page_sm
    content_for(:container_class) { 'container--sm' }
  end

  def no_container
    content_for(:container_class) { 'container--none' }
  end

  def format_time(time)
    local_time(time, '%B %e, %Y %l:%M%P %Z')
  end

  def title(page_title, append_name = true)
    page_title ||= 'Dash'
    page_title.concat(' — Dash') if append_name
    content_for(:title) { page_title }
  end

  def gravatar_url(email, name, id, size = 48)
    hex = Digest::MD5.hexdigest(email.downcase.strip)
    "https://gravatar.com/avatar/#{hex}?s=#{size}&d=https%3A%2F%2Fui-avatars.com%2Fapi%2F/#{URI.encode(name.present? ? get_initials(name) : '?')}/#{size}/#{id.present? ? user_color(id) : '97a0ad'}/fff/2/0.4/false/true"
  end

  def user_color(id)
    colors = ['006aff','7a6fff','bf66ff','ff70f3','ff6daa','ff7467','ff9500','54cb00','00cb10','00bacb']
    colors[id.to_i % colors.length] || colors.last
  end

  def avatar_for(user, size = 48, options = {})
    image = if user.class != Attendee && user&.avatar&.attached?
              user.avatar
            else
              gravatar_url(user.email, user.name, user.id, size * 2)
            end
    image_tag image, options.merge(title: user.name, alt: user.name, width: size, height: size, class: "profile-img #{options[:class]}")
  end

  def get_initials(name)
    separated = name.split(' ')
    separated.length == 2 ? "#{separated[0][0].upcase}#{separated[1][0].upcase}" : name
  end

  def filterbar_item(label, name, selected = false)
    content_tag :a, label, class: 'filterbar__item',
    tabindex: 0, role: 'tab', 'aria-selected': selected,
    data: { name: name.to_s, behavior: 'filterbar__item' }
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

  def impersonation_banner current_user, true_user
    if current_user != true_user
      content_tag :div, class: 'flash__full flash__registration-closed' do
        content_tag :p do
          content_tag(:span, "You are currently impersonating #{current_user.name}. ") +
          link_to('Stop impersonating', stop_impersonating_user_path, method: :post) +
          content_tag(:span, '.')
        end
      end
    end
  end

  def name_or_email user
    user.name.present? ? user.name : user.email
  end
end
