// pragma solidity ^0.8.0;

// contract Ticketing {
    
//     // Enum for ticket statuses
//     enum Status { Active, Expired, Cancelled }
    
//     struct Ticket {
//         bytes32 ticketId;
//         uint256 price;
//         Status status;
//     }

//     mapping(bytes32 => Ticket) public tickets;

//     // Function to create a ticket with status set to Active by default
//     function createTicket(bytes32 _ticketId, uint256 _price) external {
//         tickets[_ticketId] = Ticket(_ticketId, _price, Status.Active);
//     }

//     // Single function to update the ticket status (including marking as expired)
//     function updateTicketStatus(bytes32 _ticketId, Status newStatus) external {
//         require(tickets[_ticketId].ticketId == _ticketId, "Invalid ticket ID");
//         tickets[_ticketId].status = newStatus;
//     }

//     // Function to retrieve the ticket's current status
//     function getTicketStatus(bytes32 _ticketId) external view returns (Status) {
//         require(tickets[_ticketId].ticketId == _ticketId, "Invalid ticket ID");
//         return tickets[_ticketId].status;
//     }
// }


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ticketing {

    // Enum for ticket statuses
    enum Status { Active, Expired, Cancelled }

    // Struct to represent a ticket
    struct Ticket {
        bytes32 ticketId;       // Unique ticket ID
        uint32 price;          // Price of the ticket
        Status status;          // Current status of the ticket
        uint64 paymentId;      // Unique payment identifier for the transaction
        uint256 timestamp;      // Timestamp when the ticket was created
    }

    // Mapping to store tickets by ticket ID (bytes32)
    mapping(bytes32 => Ticket) public tickets;

    // Event to log ticket creation
    event TicketCreated(bytes32 indexed ticketId, uint32 price, uint64 paymentId, uint256 timestamp);

    // Event to log ticket status updates
    event TicketStatusUpdated(bytes32 indexed ticketId, Status newStatus);

    // Function to create a ticket with status set to Active by default
    function createTicket(bytes32 _ticketId, uint32 _price, uint64 _paymentId) external {
        // Ensure ticket doesn't already exist
        require(tickets[_ticketId].ticketId != _ticketId, "Ticket already exists");

        // Create a new ticket with a timestamp
        tickets[_ticketId] = Ticket({
            ticketId: _ticketId,
            price: _price,
            status: Status.Active, // Set status to Active by default
            paymentId: _paymentId,  // Store the payment ID
            timestamp: block.timestamp  // Store the creation timestamp
        });

        // Emit event to notify ticket creation
        emit TicketCreated(_ticketId, _price, _paymentId, block.timestamp);
    }

    // Function to update the ticket status (e.g., mark it as Expired or Cancelled)
    function updateTicketStatus(bytes32 _ticketId, Status newStatus) external {
        // Ensure ticket exists before updating
        require(tickets[_ticketId].ticketId == _ticketId, "Invalid ticket ID");

        // Update the status of the ticket
        tickets[_ticketId].status = newStatus;

        // Emit event to notify ticket status change
        emit TicketStatusUpdated(_ticketId, newStatus);
    }

    // Function to retrieve the ticket's current status along with price and timestamp
    function getTicketDetails(bytes32 _ticketId) external view returns (uint32 price, Status status, uint64 paymentId, uint256 timestamp) {
        // Ensure the ticket exists
        require(tickets[_ticketId].ticketId == _ticketId, "Invalid ticket ID");

        // Return the ticket details
        Ticket memory ticket = tickets[_ticketId];
        return (ticket.price, ticket.status, ticket.paymentId, ticket.timestamp);
    }

}
