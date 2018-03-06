import UIKit

class TicketWithTicketsDetails: Codable {
    var ticket = Ticket()
    var ticketsDetails = [TicketDetail]()
}
