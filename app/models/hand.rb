class Hand
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes
  attr_accessor :cards, :result, :error_msgs

  validate :hand_valid

  def judge_hands
    # マークと数字の分割
    @suits = cards.delete("^SDHC").chars
    @numbers = cards.delete("^0-9| ").split(" ").map(&:to_i)

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

  # バリデーションの定義
  def hand_valid
    cards_arr = cards.split(" ")
    if /\A[A-Z][0-90-9]+ [A-Z][0-90-9]+ [A-Z][0-90-9]+ [A-Z][0-90-9]+ [A-Z][0-90-9]+\z/ === cards
      cards_arr.each_with_index do |card, i|
        if card !~ /\A[SDCH]([1-9]|1[0-3])\z/
          errors[:base] << "#{i + 1}番目のカード指定文字が不正です。(#{card})\n半角英字大文字のスート(S,H,D,C)と数字(1〜13)の組み合わせでカードを指定してください。"
        end
      end
      if cards_arr.size != cards_arr.uniq.size
        errors[:base] << "カードが重複しています。"
      end
    else
      errors[:base] << "5つのカード指定文字を半角スペース区切りで入力してください。(例：S1 H3 D9 C13 S11)"
    end
  end
end
