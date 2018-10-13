class OrganizerPositionInvitesMailer < ApplicationMailer
  default from: 'invite@h-m.com'

  def notify
    @invite = params[:invite]
    mail(to: @invite.email, subject: 'Welcome to H&M')
  end
end
