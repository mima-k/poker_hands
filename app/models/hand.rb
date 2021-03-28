class Hand
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes
  attr_accessor :cards, :result, :errors

  #バリデーションの定義
  validates :cards, presence: true
                    # format: {
                    #   with: /\A[SDCH]([1-9]|1[0-3]) [SDCH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3]) [SCDH]([1-9]|1[0-3])\z/,
                    #   message: -> (rec, data) {
                    #     I18n.t('activemodel.errors.models.hand.format')
                    #   }
                    # }


  def judge_hands
    # マークと数字の分割
    suits = cards.delete("^0-9").split(" ")
    numbers = cards.delete("^A-Z").split(" ")

    if suits.uniq.size == 1
      @result = "flush"
    end

  end
  # def error_check
  #   if cards == "a"
  #     @result = "test"
  #   else
  #     @result = cards
  #   end
  # end
end
