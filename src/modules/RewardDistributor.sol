// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../interfaces/IRewardDistributor.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RewardDistributor is IRewardDistributor {
    IERC20 public immutable token;

    bytes32 public merkleRoot;

    mapping(address => bool) public claimed;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function claim(address user, uint256 amount, bytes32[] calldata proof) external override {
        if (claimed[user]) revert AlreadyClaimed();

        bytes32 leaf = keccak256(abi.encodePacked(user, amount));

        bool valid = MerkleProof.verify(proof, merkleRoot, leaf);

        if (!valid) revert InvalidProof();

        claimed[user] = true;

        token.transfer(user, amount);

        emit Claimed(user, amount);
    }

    function updateRoot(bytes32 newRoot) external override {
        merkleRoot = newRoot;
        emit RootUpdated(newRoot);
    }

    function isClaimed(address user) external view override returns (bool) {
        return claimed[user];
    }
}
