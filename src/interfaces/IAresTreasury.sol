// interface IAresTreasury {
//     struct Proposal {
//         address target;
//         uint256 value;
//         bytes data;
//         uint256 nonce;
//         uint256 eta;
//         bool queued;
//         bool executed;
//     }

//     event ProposalCreated(bytes32 indexed proposalId, address indexed proposer);
//     event ProposalQueued(bytes32 indexed proposalId, uint256 eta);
//     event ProposalExecuted(bytes32 indexed proposalId);
//     event ProposalCancelled(bytes32 indexed proposalId);

//     function propose(address target, uint256 value, bytes calldata data) external returns (bytes32);

//     function queue(bytes32 proposalId) external;

//     function execute(bytes32 proposalId) external payable;

//     function cancel(bytes32 proposalId) external;

//     function getProposal(bytes32 proposalId) external view returns (Proposal memory);
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAresTreasury {
    struct Proposal {
        address target;
        uint256 value;
        bytes data;
        uint256 nonce;
        uint256 eta;
        bool queued;
        bool executed;
    }

    event ProposalCreated(bytes32 indexed proposalId, address indexed proposer);
    event ProposalQueued(bytes32 indexed proposalId, uint256 eta);
    event ProposalExecuted(bytes32 indexed proposalId);
    event ProposalCancelled(bytes32 indexed proposalId);

    function propose(address target, uint256 value, bytes calldata data) external returns (bytes32);

    // ✅ Updated signature to match implementation
    function queue(bytes32 proposalId, uint256 nonce, bytes calldata signature) external;

    function execute(bytes32 proposalId) external payable;

    function cancel(bytes32 proposalId) external;

    function getProposal(bytes32 proposalId) external view returns (Proposal memory);
}
