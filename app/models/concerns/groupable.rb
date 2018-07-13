module Groupable
  extend ActiveSupport::Concern
  TOTAL_MEMBERS_COUNT_FOR_DISCOUNT=4.freeze

  def referrer?
    !!self.referrer
  end

  def candidate?
    !!self.candidate
  end

  def members
    return nil unless referrer?
    self.referrer.candidates
  end

  def in_a_group?
    candidate? || referrer?
  end

  def total_members
    return nil unless in_a_group?
    if referrer?
      return self.referrer.candidates.count
    end

    if candidate?
      candidate = self.candidate
      return candidate.referrer.candidates.count
    end
  end

  def equal_group_address?
    valid = []
    if referrer?
      groups = self.referrer.candidates
      referrer_address = self.full_address
    else
      groups = self.candidate.referrer.candidates
      referrer_address = self.candidate.referrer.user.active_address
    end

    return false unless groups.present?
    return false unless groups.count >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT
    return false unless referrer_address.present?

    groups.each do |member|
      valid << is_equal(member.user.active_address, referrer_address)
    end
    return valid.all? { |c| !!c }
  end

  def is_entitled_for_discount?
    total_members >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT && equal_group_address?
  end

  private

  def is_equal(member_address, referrer_address)
    [
      member_address.city.downcase == referrer_address.city.downcase,
      member_address.line1.downcase == referrer_address.line1.downcase,
      member_address.state.downcase == referrer_address.state.downcase,
      member_address.zip_code.downcase == referrer_address.zip_code.downcase
    ].all?(true)
  end
end