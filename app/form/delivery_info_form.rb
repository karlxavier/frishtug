class DeliveryInfoForm
  include ActiveModel::Model
  attr_accessor :address, :current_user

  validate :address_is_array?
  
  def save
    return false if invalid?
    persist!
  end

  private

  def persist!
    ActiveRecord::Base.transaction do
      address.each do |param|
        id = param[:id]
        to_delete = param[:_delete]
        
        remove_keys([:id, :_delete], param)

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
    return true if address.is_a?(Array)
    errors.add(:base, 'is not an array of addresses')
  end
end