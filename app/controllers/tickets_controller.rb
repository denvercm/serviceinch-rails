class TicketsController < ApplicationController

  def index
    @tickets = Ticket.page(params[:page]).order('created_at DESC').includes([:ticket_status, :ticket_priority])
    @tickets = @tickets.where(:assignee_id => current_user.id) unless current_user.user_access.is_admin
  end

  def new
    @ticket = Ticket.new(:added_by_id => current_user.id)
  end

  def create
    @ticket = Ticket.new(params[:ticket])
    success = @ticket && @ticket.save
    if success && @ticket.errors.empty?
      redirect_to tickets_path
      flash[:notice] = "Ticket added successfully..."
    else
      render :action => 'new'
    end
  end

  def show
    @ticket = Ticket.where(:id => params[:id]).includes([{:ticket_notes => :ticket_changes}]).first
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])
    tn = TicketNote.new(params["ticket_note"])
    params["ticket"].each do |k, v|
      story = @ticket.get_ticket_change_story(k, v)
      tn.ticket_changes << story if story
    end

    Ticket.transaction do
      if tn.ticket_changes.size > 0 or !tn.comments.blank?
        TicketNote.transaction do
          @ticket.ticket_notes << tn
        end
      end
      @ticket.update_attributes(params["ticket"])
      @ticket.save!
    end

    redirect_to ticket_path(@ticket.id)
  end
end
