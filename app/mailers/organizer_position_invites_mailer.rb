# frozen_string_literal: true

class OrganizerPositionInvitesMailer < ApplicationMailer
  default from: 'Dash Invitations <invitations@dash.zane.sh>'

  def notify
    @invite = params[:invite]
    mail(to: @invite.email, subject: @invite.invite_url ? 'Welcome to Dash' : 'You’ve been invited to manage an event on Dash')
  end
end
