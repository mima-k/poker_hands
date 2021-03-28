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
    @suits = cards.delete("^A-Z").chars
    @numbers = cards.delete("^0-9").chars.map(&:to_i)
    p @suits
   
    case [straight?, flash?]
    when [true, true]
      @result = "ストレートフラッシュ"
    when [true, false]
      @result = "ストレート"
    when [false, true]
      @result = "フラッシュ"
    end

  end
  # def error_check
  #   if cards == "a"
  #     @result = "test"
  #   else
  #     @result = cards
  #   end
  # end

  private
  def straight?
    nums = @numbers.uniq.sort
    return false if nums.size < 5
    nums.last - nums.first == 4 || nums[0] == 1 && nums[1] == 10 && nums[2] == 11 && nums[3] == 12 && nums[4] == 13
  end

  def flash?
    @suits.uniq.size == 1
  end
end
