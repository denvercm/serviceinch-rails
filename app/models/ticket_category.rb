class TicketCategory < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10

  has_many :tickets

  validates :name, :presence => true, :uniqueness => true

end
