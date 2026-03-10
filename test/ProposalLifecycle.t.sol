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
}
