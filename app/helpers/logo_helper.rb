module LogoHelper
  def logo(size = '215x51')
    content_tag :a, root_path, class: 'navbar-brand' do
      svg_tag 'packs/images/logo-default.svg', size: size
    end
  end
end
