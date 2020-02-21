# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    if user_signed_in?
      @events = current_user.events
      @invites = current_user.organizer_position_invites.pending

      if @events.size == 1 && @invites.size == 0 && !current_user.admin?
        redirect_to current_user.events.first
      end
    else
      render 'static'
    end
  end
end
