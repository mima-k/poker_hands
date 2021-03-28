class Hand
  include ActiveModel::Model
  attr_accessor :card, :judgement

  #バリデーションの定義
  validates :card, presence: true

  
  def judge
    if card = "d"
      judgement = "true"
    else
      judgement = "false"
    end
  end
end
