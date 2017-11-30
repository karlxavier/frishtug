# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  line1            :string
#  line2            :string
#  front_door       :string
#  city             :string
#  state            :string
#  zip_code         :string
#  addressable_type :string
#  addressable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location_at      :integer
#  latitude         :float
#  longitude        :float
#  status           :integer
#

# Column names
# id line1 line2 front_door city state zip_code addressable_type addressable_id
class Address < ApplicationRecord
  enum location_at: %i[at_work at_home multiple_workplaces]
  enum status: %i[active inactive]
  belongs_to :addressable, polymorphic: true, optional: true
  geocoded_by :full_address

  def self.specified_location
    if location_ats != :multiple_workplaces
      return where(location_at: :at_work).first
    end
    where(location_at: :multiple_workplaces)
  end

  def full_formatted_address
    formatted = <<-HEREDOC
      #{line1}#{print_line2?}#{print_front_door_code?}<br>
      #{city}, #{state} #{zip_code}<br>
      United States
    HEREDOC
    formatted.html_safe
  end

  def full_address
    [line1, line2, city, state, 'US'].compact.join(', ')
  end

  private

  def print_line2?
    line2.present? ? ", #{line2}" : ''
  end

  def print_front_door_code?
    front_door.present? ? ", #{front_door}" : ''
  end
end
