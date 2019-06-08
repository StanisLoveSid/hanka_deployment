class Warningg < ApplicationRecord
  belongs_to :day

  def reason_not_empty?
  	!(reason.empty?)
  end

  def description_not_empty?
  	!(description.empty?)
  end

end
