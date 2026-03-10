// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAuthorization {
    event SignerAdded(address signer);
    event SignerRemoved(address signer);
    event NonceUsed(address signer, uint256 nonce);

    error InvalidSignature();
    error NonceAlreadyUsed();
    error UnauthorizedSigner();

    function verify(bytes32 digest, address signer, uint256 nonce, bytes calldata signature) external returns (bool);

    function isSigner(address account) external view returns (bool);
}
