// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/core/AresTreasury.sol";
import "../src/interfaces/IAuthorization.sol";

contract Execute {
    uint256 public number;

    function setNumber(uint256 n) external {
        number = n;
    }
}

contract TimelockExecutionTest is Test {
    AresTreasury treasury;
    Execute execute;
    uint256 signerKey = 1;
    address signer;

    function setUp() public {
        signerKey = 1;
        signer = vm.addr(signerKey);
        address[] memory signers = new address[](1);
        signers[0] = signer;
        treasury = new AresTreasury(signers);
        execute = new Execute();
    }

    function testExecuteAfterDelay() public {
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", 7);
        bytes32 id = treasury.propose(address(execute), 0, data);

        IAuthorization.QueueAction memory action = IAuthorization.QueueAction({
            target: address(execute), value: 0, data: data, nonce: 0, chainId: block.chainid
        });
        bytes32 digest =
            keccak256(abi.encode(action.target, action.value, keccak256(action.data), action.nonce, action.chainId));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerKey, digest);
        bytes memory sig = abi.encodePacked(r, s, v);

        treasury.queue(id, 0, sig);
        vm.warp(block.timestamp + 2 days);
        treasury.execute(id);

        assertEq(execute.number(), 7);
    }
}

