// import "../interfaces/IAuthorization.sol";
// import "../libraries/ECDSAValidator.sol";

// contract AuthorizationModule is IAuthorization {
//     mapping(address => bool) private _signers;
//     mapping(address => mapping(uint256 => bool)) public usedNonce;

//     struct QueueAction {
//         address target;
//         uint256 value;
//         bytes data;
//         uint256 nonce;
//         uint256 chainId;
//     }

//     constructor(address[] memory signers) {
//         for (uint256 i; i < signers.length; i++) {
//             _signers[signers[i]] = true;
//             emit SignerAdded(signers[i]);
//         }
//     }

//     function verify(bytes32 digest, address signer, uint256 nonce, bytes calldata signature)
//         external
//         override
//         returns (bool)
//     {
//         if (!_signers[signer]) revert UnauthorizedSigner();
//         if (usedNonce[signer][nonce]) revert NonceAlreadyUsed();

//         address recovered = ECDSAValidator.recover(digest, signature);

//         if (recovered != signer) revert InvalidSignature();

//         usedNonce[signer][nonce] = true;

//         emit NonceUsed(signer, nonce);

//         return true;
//     }

//     function isSigner(address account) external view override returns (bool) {
//         return _signers[account];
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../interfaces/IAuthorization.sol";
import "../libraries/ECDSAValidator.sol";

contract AuthorizationModule is IAuthorization {
    mapping(address => bool) private _signers;
    mapping(address => mapping(uint256 => bool)) public usedNonce;

    // ❌ REMOVED: Struct is now in Interface

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

        return recovered; // Return who actually signed
    }

    function isSigner(address account) external view override returns (bool) {
        return _signers[account];
    }
}
