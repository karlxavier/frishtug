# frozen_string_literal: true

module Groupable
  extend ActiveSupport::Concern
  TOTAL_MEMBERS_COUNT_FOR_DISCOUNT = 4

  def referrer?
    !!referrer
  end

  def candidate?
    !!candidate
  end

  def members
    return candidate.referrer.candidates unless referrer?
    referrer.candidates
  end

  def in_a_group?
    candidate? || referrer?
  end

  def total_members
    return nil unless in_a_group?
    return referrer.candidates.count if referrer?

    if candidate?
      candidate = self.candidate
      return candidate.referrer.candidates.count
    end
  end

  def equal_group_address?
    valid = []
    if referrer?
      groups = referrer.candidates
      referrer_address = full_address
    else
      groups = candidate.referrer.candidates
      referrer_address = candidate.referrer.user.full_address
    end

    return false unless groups.present?
    return false unless groups.count >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT
    return false unless referrer_address.present?

    groups.each do |member|
      valid << (member.user.full_address == referrer_address)
    end
    valid.all? { |c| !!c }
  end

  def is_entitled_for_discount?
    total_members >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT && equal_group_address?
  end

  private
end
