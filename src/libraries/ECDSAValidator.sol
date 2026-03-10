// library ECDSAValidator {
//     function recover(bytes32 digest, bytes memory signature) internal pure returns (address) {
//         bytes32 r;
//         bytes32 s;
//         uint8 v;

//         assembly {
//             r := mload(add(signature, 32))
//             s := mload(add(signature, 64))
//             v := byte(0, mload(add(signature, 96)))
//         }

//         return ecrecover(digest, v, r, s);
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library ECDSAValidator {
    function recover(bytes32 digest, bytes memory signature) internal pure returns (address) {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        // Prevent malleability attacks
        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "Invalid s value");
        require(v == 27 || v == 28, "Invalid v value");

        return ecrecover(digest, v, r, s);
    }
}
