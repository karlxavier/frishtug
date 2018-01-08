module PagesHelper
  def image_asset(obj, options = {})
    return nil unless obj.asset_id?
    options[:fetch_format] = :auto
    options[:quality] = :auto
    cl_image_tag obj.asset.image, options
  end

  def random_background
    assets = Store.first.assets
    return nil unless assets.present?
    cl_image_path(assets.sample(1).first.image, fetch_format: :auto, quality: :auto)
  end

  def admin_dashboard_link
    return nil unless current_admin.present?
    content_tag :li, class: 'nav-item' do
      link_to_custom 'Dashboard', admin_dashboard_index_path
    end
  end

  def user_dashboard_link
    return nil unless current_user.present?
    content_tag :li, class: 'nav-item' do
      link_to_custom 'Dashboard', user_dashboard_index_path
    end
  end

  def login_link
    return nil if current_user.present?
    content_tag :li, class: "nav-item #{active?(new_user_session_path)}" do
      link_to_custom 'Log In', new_user_session_path
    end
  end

  def sign_up_link
    return nil if current_user.present?
    content_tag :li, class: 'nav-item' do
      link_to 'Sign Up', user_registrations_path,
        class: 'btn btn-brown-outline-rounded font-family-montserrat-semi-bold text-uppercase font-size-15'
    end
  end

  private

  def link_to_custom(name, path, options= {})
    options[:class] = 'nav-link font-size-15 font-family-montserrat'
    link_to name, path, options
  end
end