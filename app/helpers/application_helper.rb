module ApplicationHelper
  require 'calendar'
  def nav_link(content, path, args = { class: 'nav-link' })
    klass = args
    link_to(content, path, klass)
  end

  def active?(path)
    'active' if current_page?(path)
  end

  def admin_signout_link
    css_class = 'nav-link ml-auto'
    if current_admin
      link_to 'Logout', destroy_admin_session_path, method: :delete, class: css_class
    end
  end

  def user_signout_link
    css_class = 'nav-link ml-auto'
    if current_user
      link_to 'Logout', destroy_user_session_path, method: :delete, class: css_class
    end
  end

  def modal_for(id, title, &block)
    content = capture(&block) if block_given?
    render 'shared/modal', id: id, title: title, content: content
  end

  def card_container(&block)
    return 'no block given' unless block_given?
    content = capture(&block)
    render 'shared/card_container', content: content
  end

  def card(&block)
    return 'no block given' unless block_given?
    content = capture(&block)
    render 'shared/card', content: content
  end

  def alert_flash(key)
    alerts = {
      success: 'alert-success',
      error: 'alert-danger',
      notice: 'alert-info'
    }
    alerts[key.to_sym]
  end

  def trailing(text, length, str)
    text.to_s.rjust(length, str)
  end

  def render_class(klass, **options)
    render klass.class.to_s.underscore, options
  end

  def link_to_btn(text, path, klass=nil, id=nil)
    klass ||= 'btn-brown'
    id ||= text.parameterize.underscore
    link_to text, path, class: "btn text-uppercase #{klass}", id: id
  end

  def has_address(source)
    return false unless source.address_line1.present?
    true
  end

  def address_from_source(source)
    address = <<-HEREDOC
      #{source.address_line1}#{source.address_line2.empty? ? '' : ", #{source.address_line2}"} <br>
      #{source.address_city}, #{source.address_state} #{source.address_zip} <br>
      #{source.address_country}
    HEREDOC
    address.html_safe
  end

  def calendar(date = Date.current, disable_date = nil, &block)
    Calendar.new(self, date, disable_date, block).table_compact
  end

  def disabled_text
    '<i class="fa fa-spinner fa-spin"></i> Processing...'
  end
end
