class Movie < ActiveRecord::Base
  def self.ratings
    return find(:all, :select => 'distinct rating').map(&:rating)
  end
end
