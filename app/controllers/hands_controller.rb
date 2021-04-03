class HandsController < ApplicationController
  protect_from_forgery except: :index

  def index
    if request.post?
      @hand = Hand.new(cards: params[:cards])
      if @hand.valid?
        @hand.judge_hands
      end
    else
      @hand = Hand.new
    end
  end
end
