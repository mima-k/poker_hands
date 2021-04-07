module PokerJudgeService
  class Hand
    include ActiveModel::Model
    attr_accessor :cards, :result

    SUIT_REGEX = "^SDHC"
    NUMBER_REGEX = "^0-9| "
    VALID_HANDS_REGEX = /\A[A-Z][0-90-9]+ [A-Z][0-90-9]+ [A-Z][0-90-9]+ [A-Z][0-90-9]+ [A-Z][0-90-9]+\z/
    VALID_CARD_REGEX = /\A[SDCH]([1-9]|1[0-3])\z/

    def judge
      if hand_valid?
        poker_hand
      else
        false
      end
    end

    private

    def poker_hand
      # マークと数字の分割
      @suits = cards.delete(SUIT_REGEX).chars
      @numbers = cards.delete(NUMBER_REGEX).split(" ").map(&:to_i)

      if straight? && flash?
        @result = "ストレートフラッシュ"
      elsif duplication_count == 4
        @result = "フォー・オブ・ア・カインド"
      elsif duplication_count != 4 && @numbers.uniq.size == 2
        @result = "フルハウス"
      elsif flash?
        @result = "フラッシュ"
      elsif straight?
        @result = "ストレート"
      elsif duplication_count == 3
        @result = "スリー・オブ・ア・カインド"
      elsif duplication_count != 3 && @numbers.uniq.size == 3
        @result = "ツーペア"
      elsif @numbers.uniq.size == 4
        @result = "ワンペア"
      else
        @result = "ハイカード"
      end
    end

    # ストレート判定
    def straight?
      nums = @numbers.uniq.sort
      return false if nums.size < 5
      (nums.last - nums.first == 4) || (nums == [1,10,11,12,13])
    end

    # フラッシュ判定
    def flash?
      @suits.uniq.size == 1
    end

    # 手札の中で重複数が最大となる数字を返す
    def duplication_count
      most = @numbers.max_by { |a| @numbers.count(a) }
      return @numbers.count(most)
    end

    # バリデーションの定義
    def hand_valid?
      cards_arr = cards.split(" ")
      if VALID_HANDS_REGEX === cards
        cards_arr.each_with_index do |card, i|
          if card !~ VALID_CARD_REGEX
            errors[:base] << "#{i + 1}番目のカード指定文字が不正です。(#{card})\n半角英字大文字のスート(S,H,D,C)と数字(1〜13)の組み合わせでカードを指定してください。"
            return false
          end
        end
        if cards_arr.size != cards_arr.uniq.size
          errors[:base] << "カードが重複しています。"
          return false
        end
        return true
      else
        errors[:base] << "5つのカード指定文字を半角スペース区切りで入力してください。(例：S1 H3 D9 C13 S11)"
        return false
      end
    end
  end
end
