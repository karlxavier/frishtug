module BootstrapHelper
  def fluid_jumbotron(klass = nil, &block)
    content_tag :div, class: "jumbotron jumbotron-fluid #{klass}" do
      content_tag :div, class: 'container' do
        yield block if block_given?
      end
    end
  end

  def full_width_jumbotron(klass = nil, &block)
    content_tag :div, class: "jumbotron jumbotron-fluid #{klass}" do
      content_tag :div, class: 'container-fluid' do
        yield block if block_given?
      end
    end
  end

  ['display-1', 'display-2', 'display-3', 'display-4'].each do |method|
    define_method method.underscore.to_sym do |content|
      content_tag :h1, class: method do
        "#{content}"
      end
    end
  end
end