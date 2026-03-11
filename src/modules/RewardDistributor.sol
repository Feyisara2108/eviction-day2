// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../interfaces/IRewardDistributor.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardDistributor is IRewardDistributor, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable TOKEN;
    bytes32 public merkleRoot;
    mapping(address => bool) public claimed;

    constructor(address _token) Ownable(msg.sender) {
        TOKEN = IERC20(_token);
    }

    function claim(IRewardDistributor.ClaimData calldata claimData) external override {
        if (claimed[claimData.user]) revert AlreadyClaimed();

        bytes32 leaf = keccak256(abi.encodePacked(claimData.user, claimData.amount));
        bool valid = MerkleProof.verify(claimData.proof, merkleRoot, leaf);

        if (!valid) revert InvalidProof();

        claimed[claimData.user] = true;
        TOKEN.safeTransfer(claimData.user, claimData.amount);

        emit Claimed(claimData.user, claimData.amount);
    }

    function updateRoot(bytes32 newRoot) external override onlyOwner {
        merkleRoot = newRoot;
        emit RootUpdated(newRoot);
    }

    function isClaimed(address user) external view override returns (bool) {
        return claimed[user];
    }
}
