module User::CreateNewMonthsHelper
  def back_to_create_new_month_link(text, options)
    link_to user_create_new_months_path(options), class: 'dark-font-color' do
      "<i class='fa fa-chevron-left'></i> #{text}".html_safe
    end
  end
end
