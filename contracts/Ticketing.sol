// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ticketing {
    
    // Enum for ticket statuses
    enum Status { Active, Expired, Cancelled }
    
    struct Ticket {
        bytes32 ticketId;
        uint256 price;
        Status status;
    }

    mapping(bytes32 => Ticket) public tickets;

    // Function to create a ticket with status set to Active by default
    function createTicket(bytes32 _ticketId, uint256 _price) external {
        tickets[_ticketId] = Ticket(_ticketId, _price, Status.Active);
    }

    // Single function to update the ticket status (including marking as expired)
    function updateTicketStatus(bytes32 _ticketId, Status newStatus) external {
        require(tickets[_ticketId].ticketId == _ticketId, "Invalid ticket ID");
        tickets[_ticketId].status = newStatus;
    }

    // Function to retrieve the ticket's current status
    function getTicketStatus(bytes32 _ticketId) external view returns (Status) {
        require(tickets[_ticketId].ticketId == _ticketId, "Invalid ticket ID");
        return tickets[_ticketId].status;
    }
}
