module ApplicationHelper
  def nav_link(content, path, *array)
    link_to(content, path, *array, class: 'nav-link')
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

  def modal_for(id, title, &block)
    content = capture(&block) if block_given?
    render 'shared/modal', id: id, title: title, content: content
  end

  def alert_flash(key)
    alerts = {
      success: 'alert-success',
      error: 'alert-danger',
      notice: 'alert-info'
    }
    alerts[key.to_sym]
  end
end
