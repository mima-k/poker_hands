class HandsController < ApplicationController
  protect_from_forgery except: :index
  def index
    @hand = Hand.new
    if request.post?
      hand = params.permit(:card)
      @hand = Hand.new(hand) unless hand.nil?
    end
  end
end
