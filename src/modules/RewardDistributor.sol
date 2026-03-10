// import "../interfaces/IRewardDistributor.sol";
// import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract RewardDistributor is IRewardDistributor {
//     IERC20 public immutable token;

//     bytes32 public merkleRoot;

//     mapping(address => bool) public claimed;

//     constructor(address _token) {
//         token = IERC20(_token);
//     }

//     function claim(address user, uint256 amount, bytes32[] calldata proof) external override {
//         if (claimed[user]) revert AlreadyClaimed();

//         bytes32 leaf = keccak256(abi.encodePacked(user, amount));

//         bool valid = MerkleProof.verify(proof, merkleRoot, leaf);

//         if (!valid) revert InvalidProof();

//         claimed[user] = true;

//         token.transfer(user, amount);

//         emit Claimed(user, amount);
//     }

//     function updateRoot(bytes32 newRoot) external override {
//         merkleRoot = newRoot;
//         emit RootUpdated(newRoot);
//     }

//     function isClaimed(address user) external view override returns (bool) {
//         return claimed[user];
//     }
// }

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

    // ❌ REMOVED: Struct is now in Interface

    constructor(address _token) Ownable(msg.sender) {
        token = IERC20(_token);
    }

    // ✅ Use Interface Struct: IRewardDistributor.ClaimData
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
