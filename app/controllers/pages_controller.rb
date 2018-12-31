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
    else
      redirect_to new_user_session_path
    end
  end
end
