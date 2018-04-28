module SvgHelper
  def svg_image_tag(filename, options = {})
    assets = Rails.application.assets
    file = File.read(Rails.root.join('public', 'packs', 'packs/images', file_name))
    file.html_safe
  end

  def svg_tag(file_path, options = {})
    options[:width], options[:height] = extract_dimensions(options[:size]) if options[:size]

    file_name = extract_filename(file_path)
    file = File.read(Rails.root.join('public', 'packs', 'packs/images', file_name)).force_encoding("UTF-8")
    document = Nokogiri::HTML::DocumentFragment.parse file
    svg = document.at_css 'svg'

    svg['class']  = options[:class] if options[:class]
    svg['id']     = options[:id] if options[:id]
    svg['width']  = options[:width] if options[:width]
    svg['height'] = options[:height] if options[:height]

    raw document
  end

  private

  def extract_filename(file_path)
    Webpacker.manifest.lookup!(file_path).split('/').last
  end

  def extract_dimensions(options)
    options.split('x')
  end
end