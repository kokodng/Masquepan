import Foundation

class TicketWithTicketsDetails: Decodable {
    var ticket = Ticket()
    var ticketsDetails = [TicketDetail]()
}
