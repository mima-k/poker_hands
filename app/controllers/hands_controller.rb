class HandsController < ApplicationController
  protect_from_forgery except: :index
  include PokerJudgeService

  def index
    if request.post?
      @hand = Hand.new(cards: params[:cards])
      @hand.judge
    else
      @hand = Hand.new
    end
  end
end
