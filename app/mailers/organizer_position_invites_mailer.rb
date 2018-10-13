# frozen_string_literal: true

class OrganizerPositionInvitesMailer < ApplicationMailer
  default from: 'H&M Invitations <invitations@h-m.zane.sh>'

  def notify
    @invite = params[:invite]
    mail(to: @invite.email, subject: @invite.invite_url ? 'Welcome to H&M' : 'You’ve been invited to manage an event on H&M')
  end
end
