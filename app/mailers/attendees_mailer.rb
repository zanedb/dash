# frozen_string_literal: true

class AttendeesMailer < ApplicationMailer
  default from: 'Hack Pennsylvania Team <mail@hackpennteam.com>'

  self.smtp_settings = {
    address: 'smtp.postmarkapp.com', port: 587,
    domain: 'hackpennteam.com',
    authentication: 'plain',
    user_name: 'c25eccc3-ee17-4a77-9126-b24dfc6c2a3f',
    password: 'c25eccc3-ee17-4a77-9126-b24dfc6c2a3f',
    enable_starttls_auto: false
  }

  def attendee_confirmation
    @attendee = params[:attendee]
    mail(to: @attendee.email, subject: 'Important information about Hack Pennsylvania')
  end
end
