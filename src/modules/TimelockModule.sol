// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract TimelockModule {
    uint256 public constant DELAY = 2 days;

    error TooEarly();
    error AlreadyQueued();

    mapping(bytes32 => uint256) public executionTime;

    function queue(bytes32 proposalId) external {
        if (executionTime[proposalId] != 0) revert AlreadyQueued();

        executionTime[proposalId] = block.timestamp + DELAY;
    }

    function validateExecution(bytes32 proposalId) external view {
        uint256 eta = executionTime[proposalId];

        if (block.timestamp < eta) revert TooEarly();
    }
}
