class DeliveryInfoForm
  include ActiveModel::Model
  attr_accessor :addresses, :current_user

  validate :address_is_array?
  validate :address_presence?

  def save
    return false if invalid?
    persist!
  end

  private

  def persist!
    ActiveRecord::Base.transaction do
      addresses.each do |param|
        id = param[:id]
        to_delete = param[:_delete]

        remove_keys(%i[id _delete], param)

        if id.nil?
          current_user.addresses.create!(param)
          next
        end

        address = Address.find(id)
        if to_delete == 1
          address.destroy
          next
        end
        address.update_attributes!(param)
      end
    end
    true
  rescue ActiveRecord::StatementInvalid => e
    errors.add(:base, e.message)
    false
  end

  def remove_keys(keys, param)
    keys.map { |k| param.delete k }
  end

  def address_is_array?
    return true if addresses.is_a?(Array)
    errors.add(:base, 'is not an array of addresses')
  end

  def address_presence?
    to_validate = %w[line1 city state zip_code]
    addresses.each do |a|
      to_validate.each do |v|
        errors.add(:base, "Address #{v} cant be blank.") if a[v.to_sym].blank?
      end
    end
  end
end
