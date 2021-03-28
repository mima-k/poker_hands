class HandsController < ApplicationController
  protect_from_forgery except: :index
  def index
    @hand = Hand.new
    if request.post?
      @hand = Hand.new(cards: params[:cards])
      @hand.error_check
    end
  end
end
