// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library ProposalHashLib {
    function hashProposal(address target, uint256 value, bytes memory data, uint256 nonce, uint256 chainId)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(target, value, keccak256(data), nonce, chainId));
    }
}
