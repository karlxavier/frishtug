module ForceFill
  def fill_in_with_force(locator, with:)
    field_id = find_field(locator)[:id]
    page.execute_script "document.querySelector('##{field_id}').value = '#{with}';"
  end

  alias_method :ffill_in, :fill_in_with_force
end