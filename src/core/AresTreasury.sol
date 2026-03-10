// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../interfaces/IAresTreasury.sol";
import "../modules/AuthorizationModule.sol";
import "../modules/TimelockModule.sol";
import "../libraries/ProposalHashLib.sol";

contract AresTreasury is IAresTreasury {
    error ProposalNotQueued();
    error AlreadyExecuted();
    error ExecutionFailed();

    AuthorizationModule public auth;
    TimelockModule public timelock;

    uint256 public proposalNonce;

    mapping(bytes32 => Proposal) public proposals;

    constructor(address[] memory signers) {
        auth = new AuthorizationModule(signers);
        timelock = new TimelockModule();
    }

    function propose(address target, uint256 value, bytes calldata data) external override returns (bytes32) {
        bytes32 proposalId = ProposalHashLib.hashProposal(target, value, data, proposalNonce, block.chainid);

        proposals[proposalId] = Proposal({
            target: target, value: value, data: data, nonce: proposalNonce, eta: 0, queued: false, executed: false
        });

        proposalNonce++;

        emit ProposalCreated(proposalId, msg.sender);

        return proposalId;
    }

    function queue(bytes32 proposalId, uint256 nonce, bytes calldata signature) external override {
        Proposal storage p = proposals[proposalId];

        IAuthorization.QueueAction memory action = IAuthorization.QueueAction({
            target: p.target, value: p.value, data: p.data, nonce: nonce, chainId: block.chainid
        });

        auth.verify(action, signature);

        timelock.queue(proposalId);
        p.queued = true;
        p.eta = block.timestamp + timelock.DELAY();
        emit ProposalQueued(proposalId, p.eta);
    }

    function execute(bytes32 proposalId) external payable override {
        Proposal storage p = proposals[proposalId];

        if (!p.queued) revert ProposalNotQueued();
        if (p.executed) revert AlreadyExecuted();

        timelock.validateExecution(proposalId);

        p.executed = true;

        (bool success,) = p.target.call{value: p.value}(p.data);

        if (!success) revert ExecutionFailed();

        emit ProposalExecuted(proposalId);
    }

    function cancel(bytes32 proposalId) external override {
        if (!proposals[proposalId].queued) revert ProposalNotQueued();
        delete proposals[proposalId];
        emit ProposalCancelled(proposalId);
    }

    function getProposal(bytes32 proposalId) external view override returns (Proposal memory) {
        return proposals[proposalId];
    }
}
