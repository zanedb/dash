# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    if user_signed_in?
      @events = if current_user.admin?
                  Event.all
                else
                  current_user.events
                end
      @invites = current_user.organizer_position_invites.pending
    end
  end
end
