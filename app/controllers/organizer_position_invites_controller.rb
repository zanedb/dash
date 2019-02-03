class OrganizerPositionInvitesController < ApplicationController
  before_action :please_sign_in
  before_action :set_event

  def new
    @invite = OrganizerPositionInvite.new
    @invite.event = @event
    authorize @invite
  end

  def create
    @invite = OrganizerPositionInvite.new(invite_params)
    @invite.event = @event
    @invite.sender = current_user

    authorize @invite

    # if user doesn't exist, invite them & set URL to account invitation
    located_user = User.find_by(email: invite_params[:email])
    if located_user
      @invite.user = located_user
    else
      user = User.invite!(email: invite_params[:email]) do |u|
        u.skip_invitation = true
      end
      @invite.user = user
      @invite.invite_url = accept_user_invitation_url(invitation_token: user.raw_invitation_token)
    end

    if @invite.save
      flash[:success] = 'Invite successfully sent'
      redirect_to @invite.event
    else
      render :new
    end
  end

  def show
    @invite = OrganizerPositionInvite.find(params[:id])
    authorize @invite
  end

  def destroy
    @invite = OrganizerPositionInvite.find(params[:id])
    authorize @invite

    @invite.destroy
    redirect_to @invite.event
    flash[:success] = 'Invite was successfully destroyed.'
  end

  def accept
    @invite = OrganizerPositionInvite.find(params[:organizer_position_invite_id])
    authorize @invite

    if @invite.accept
      flash[:success] = 'You’ve accepted your invitation!'
      redirect_to @invite.event
    else
      flash[:error] = 'Failed to accept the invitation.'
      redirect_to event_organizer_position_invite_path(@event, @invite)
    end
  end

  def reject
    @invite = OrganizerPositionInvite.find(params[:organizer_position_invite_id])
    authorize @invite

    if @invite.reject
      flash[:success] = 'You’ve rejected your invitation.'
      redirect_to root_path
    else
      flash[:error] = 'Failed to reject the invitation.'
      redirect_to event_organizer_position_invite_path(@event, @invite)
    end
  end

  private

  def invite_params
    params.require(:organizer_position_invite).permit(:email)
  end
end
