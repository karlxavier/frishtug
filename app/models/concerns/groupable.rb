module Groupable
  extend ActiveSupport::Concern
  TOTAL_MEMBERS_COUNT_FOR_DISCOUNT=1.freeze

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
      referrer_address = self.candidate.referrer.user.full_address
    end

    return false unless groups.present?
    return false unless groups.count >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT
    return false unless referrer_address.present?

    groups.each do |member|
      valid << (member.user.full_address == referrer_address)
    end
    return valid.all? { |c| !!c }
  end

  def is_entitled_for_discount?
    total_members >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT && equal_group_address?
  end
end