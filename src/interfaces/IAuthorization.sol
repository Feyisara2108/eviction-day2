// interface IAuthorization {
//     event SignerAdded(address signer);
//     event SignerRemoved(address signer);
//     event NonceUsed(address signer, uint256 nonce);

//     error InvalidSignature();
//     error NonceAlreadyUsed();
//     error UnauthorizedSigner();

//     function verify(bytes32 digest, address signer, uint256 nonce, bytes calldata signature) external returns (bool);

//     function isSigner(address account) external view returns (bool);
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAuthorization {
    event SignerAdded(address signer);
    event SignerRemoved(address signer);
    event NonceUsed(address signer, uint256 nonce);

    error InvalidSignature();
    error NonceAlreadyUsed();
    error UnauthorizedSigner();

    // ✅ Define struct ONLY in interface
    struct QueueAction {
        address target;
        uint256 value;
        bytes data;
        uint256 nonce;
        uint256 chainId;
    }

    function verify(QueueAction calldata action, bytes calldata signature) external returns (address); // Returns recovered signer

    function isSigner(address account) external view returns (bool);
}
