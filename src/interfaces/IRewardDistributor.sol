// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IRewardDistributor {
    event RootUpdated(bytes32 newRoot);
    event Claimed(address indexed user, uint256 amount);

    error AlreadyClaimed();
    error InvalidProof();

    struct ClaimData {
        address user;
        uint256 amount;
        bytes32[] proof;
    }

    function claim(ClaimData calldata claim) external;

    function updateRoot(bytes32 newRoot) external;

    function isClaimed(address user) external view returns (bool);
}
