class Event < ActiveRecord::Base
  MONTHS_WITH_31_DAYS = [1, 3, 5, 7, 8, 10, 12];
  MONTH_NAMES = ["January", "February", "March", "April", "May", "June", "July",
                 "August", "September", "October", "November", "December"]
  
  validates :name, presence: true
  validates :year, presence: true, if: Proc.new { |event| event.month.present? }
  validate :month_is_valid, if: Proc.new { |event| event.month.present? }
  validates :month, presence: true, if: Proc.new { |event| event.day.present? }
  validate :day_is_valid_within_month, if: Proc.new { |event| event.month.present? && event.day.present? }
  
  belongs_to :user

  def Event.month_name(num)
    MONTH_NAMES[num - 1]
  end
  
  def month_is_valid
    errors.add(:month, "is not valid") unless self.month.between?(1,12)
  end
  
  def day_is_valid_within_month
    return unless self.month.between?(1,12)
    
    valid_days = (0..29).to_a
    valid_days << 30 unless self.month == 2
    valid_days << 31 if MONTHS_WITH_31_DAYS.include?(self.month)
    
    errors.add(:day, "#{self.day} is not valid in #{Event.month_name(self.month)}") unless valid_days.include?(self.day)
  end
  
  def format_date
    return if self.year.blank?
    month_str = Event.month_name(self.month)
    if self.day.present?
      day_str = self.day.ordinalize
      "#{month_str} #{day_str}, #{self.year}"
    else
      "#{month_str} #{self.year}"
    end
  end
end
