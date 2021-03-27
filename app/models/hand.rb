class Hand
  include ActiveModel::Model
  attr_accessor :card

  #バリデーションの定義
  validates :card, presence: true
end
