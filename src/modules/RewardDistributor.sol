// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../interfaces/IRewardDistributor.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardDistributor is IRewardDistributor, Ownable {
    IERC20 public immutable token;
    bytes32 public merkleRoot;
    mapping(address => bool) public claimed;

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    function claim(IRewardDistributor.ClaimData calldata claim) external override {
        if (claimed[claim.user]) revert AlreadyClaimed();

        bytes32 leaf = keccak256(abi.encodePacked(claim.user, claim.amount));
        bool valid = MerkleProof.verify(claim.proof, merkleRoot, leaf);

        if (!valid) revert InvalidProof();

        claimed[claim.user] = true;
        token.transfer(claim.user, claim.amount);

        emit Claimed(claim.user, claim.amount);
    }

    function updateRoot(bytes32 newRoot) external override onlyOwner {
        merkleRoot = newRoot;
        emit RootUpdated(newRoot);
    }

    function isClaimed(address user) external view override returns (bool) {
        return claimed[user];
    }
}
