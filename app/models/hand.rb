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
    @suits = cards.delete("^SDHC").chars
    @numbers = cards.delete("^0-9| ").split(" ").map(&:to_i)
    p @numbers
   
    case [straight?, flash?]
    when [true, true]
      @result = "ストレートフラッシュ"
    when [true, false]
      @result = "ストレート"
    when [false, true]
      @result = "フラッシュ"
    end

    if dup_check == 4
      @result = "フォー・オブ・ア・カインド"
    elsif dup_check != 4 && @numbers.uniq.size == 2
      @result = "フルハウス"
    elsif dup_check == 3
      @result = "スリー・オブ・ア・カインド"
    elsif dup_check != 3 && @numbers.uniq.size == 3
      @result = "ツーペア"
    elsif @numbers.uniq.size == 4
      @result = "ワンペア"
    else
      @result = "ハイカード"
    end

  end

  private
  # ストレート判定
  def straight?
    nums = @numbers.uniq.sort
    return false if nums.size < 5
    nums.last - nums.first == 4 || nums[0] == 1 && nums[1] == 10 && nums[2] == 11 && nums[3] == 12 && nums[4] == 13
  end

  # フラッシュ判定
  def flash?
    @suits.uniq.size == 1
  end

  # 手札の中で数字の重複数の最大を返す
  def dup_check
    most = @numbers.max_by { |a| @numbers.count(a) }
    return @numbers.count(most)
  end
end
