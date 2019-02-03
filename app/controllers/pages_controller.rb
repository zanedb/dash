# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    if user_signed_in?
      @events = current_user.events
      @invites = current_user.organizer_position_invites.pending
    else
      redirect_to new_user_session_path
    end
  end
end
