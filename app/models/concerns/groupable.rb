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

  def is_entitled_for_discount?
    total_members >= TOTAL_MEMBERS_COUNT_FOR_DISCOUNT
  end
end