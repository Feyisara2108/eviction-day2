// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IRewardDistributor {
    event RootUpdated(bytes32 newRoot);
    event Claimed(address indexed user, uint256 amount);

    error AlreadyClaimed();
    error InvalidProof();

    function claim(address user, uint256 amount, bytes32[] calldata proof) external;

    function updateRoot(bytes32 newRoot) external;

    function isClaimed(address user) external view returns (bool);
}
