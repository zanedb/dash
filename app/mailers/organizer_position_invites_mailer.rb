class OrganizerPositionInvitesMailer < ApplicationMailer
  default from: 'invitations@h-m.zane.sh'

  def notify
    @invite = params[:invite]
    mail(to: @invite.email, subject: 'Welcome to H&M')
  end
end
