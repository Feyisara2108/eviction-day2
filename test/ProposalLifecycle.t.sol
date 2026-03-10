// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/core/AresTreasury.sol";
import "../src/interfaces/IAresTreasury.sol";
import "../src/interfaces/IAuthorization.sol";

contract ProposalLifecycleTest is Test {
    AresTreasury treasury;
    uint256 signerKey = 1;
    address signer;

    function setUp() public {
        signerKey = 1;
        signer = vm.addr(signerKey);
        address[] memory signers = new address[](1);
        signers[0] = signer;
        treasury = new AresTreasury(signers);
    }

    function testProposalCreation() public {
        bytes32 id = treasury.propose(address(10), 0, abi.encodeWithSignature("doSomething()"));
        IAresTreasury.Proposal memory p = treasury.getProposal(id);
        assertEq(p.target, address(10));
        assertEq(p.executed, false);
    }

    function testQueueProposal() public {
        bytes32 id = treasury.propose(address(10), 0, "");

        IAuthorization.QueueAction memory action =
            IAuthorization.QueueAction({target: address(10), value: 0, data: "", nonce: 0, chainId: block.chainid});

        bytes32 digest =
            keccak256(abi.encode(action.target, action.value, keccak256(action.data), action.nonce, action.chainId));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerKey, digest);
        bytes memory sig = abi.encodePacked(r, s, v);

        treasury.queue(id, 0, sig);

        IAresTreasury.Proposal memory p = treasury.getProposal(id);
        assertTrue(p.queued);
    }
}
