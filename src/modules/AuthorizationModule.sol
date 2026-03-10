// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../interfaces/IAuthorization.sol";
import "../libraries/ECDSAValidator.sol";

contract AuthorizationModule is IAuthorization {
    mapping(address => bool) private _signers;
    mapping(address => mapping(uint256 => bool)) public usedNonce;

    constructor(address[] memory signers) {
        for (uint256 i; i < signers.length; i++) {
            _signers[signers[i]] = true;
            emit SignerAdded(signers[i]);
        }
    }

    function verify(IAuthorization.QueueAction calldata action, bytes calldata signature)
        external
        override
        returns (address)
    {
        bytes32 digest = keccak256(
            abi.encode(action.target, action.value, keccak256(action.data), action.nonce, action.chainId)
        );

        address recovered = ECDSAValidator.recover(digest, signature);

        if (!_signers[recovered]) revert UnauthorizedSigner();
        if (usedNonce[recovered][action.nonce]) revert NonceAlreadyUsed();

        usedNonce[recovered][action.nonce] = true;
        emit NonceUsed(recovered, action.nonce);

        return recovered; // Return who signed
    }

    function isSigner(address account) external view override returns (bool) {
        return _signers[account];
    }
}
