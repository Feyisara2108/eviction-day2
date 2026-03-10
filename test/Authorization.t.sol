// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/modules/AuthorizationModule.sol";
import "../src/interfaces/IAuthorization.sol";

contract AuthorizationTest is Test {
    AuthorizationModule auth;
    uint256 signerKey = 1;
    address signer;

    function setUp() public {
        signer = vm.addr(signerKey);
        address[] memory signers = new address[](1);
        signers[0] = signer;
        auth = new AuthorizationModule(signers);
    }

    function test_RevertWhen_NonceReused() public {
        IAuthorization.QueueAction memory action =
            IAuthorization.QueueAction({target: address(10), value: 0, data: "", nonce: 1, chainId: block.chainid});

        bytes32 digest =
            keccak256(abi.encode(action.target, action.value, keccak256(action.data), action.nonce, action.chainId));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerKey, digest);
        bytes memory sig = abi.encodePacked(r, s, v);

        auth.verify(action, sig);

        vm.expectRevert(IAuthorization.NonceAlreadyUsed.selector);
        auth.verify(action, sig);
    }
}
