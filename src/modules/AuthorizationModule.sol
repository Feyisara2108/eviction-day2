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

    function verify(bytes32 digest, address signer, uint256 nonce, bytes calldata signature)
        external
        override
        returns (bool)
    {
        if (!_signers[signer]) revert UnauthorizedSigner();
        if (usedNonce[signer][nonce]) revert NonceAlreadyUsed();

        address recovered = ECDSAValidator.recover(digest, signature);

        if (recovered != signer) revert InvalidSignature();

        usedNonce[signer][nonce] = true;

        emit NonceUsed(signer, nonce);

        return true;
    }

    function isSigner(address account) external view override returns (bool) {
        return _signers[account];
    }
}
