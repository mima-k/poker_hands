class Hand
  include ActiveModel::Model
  attr_accessor :cards, :result, :errors

  #バリデーションの定義
  validates :cards, presence: true

  
  def error_check
    if cards == "a"
      @result = "test"
    else
      @result = cards
    end
  end
end
