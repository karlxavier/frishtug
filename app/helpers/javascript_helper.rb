module JavascriptHelper
  def script_tag(js_file, args = {})
    content_tag(:script, type: 'text/javascript') do
      render(file: "javascripts/#{js_file}", locals: args)
    end
  end
end