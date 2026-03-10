// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/modules/RewardDistributor.sol";
import "../src/interfaces/IRewardDistributor.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("T", "T") {
        _mint(msg.sender, 1e24);
    }
}

contract RewardClaimTest is Test {
    RewardDistributor distributor;
    MockToken token;
    address user = address(5);

    function setUp() public {
        token = new MockToken();
        distributor = new RewardDistributor(address(token));
        token.transfer(address(distributor), 1000 ether);
    }

    function testClaim() public {
        bytes32 leaf = keccak256(abi.encodePacked(user, uint256(100 ether)));
        distributor.updateRoot(leaf);

        IRewardDistributor.ClaimData memory claim =
            IRewardDistributor.ClaimData({user: user, amount: 100 ether, proof: new bytes32[](0)});

        vm.prank(user);
        distributor.claim(claim);

        assertTrue(distributor.claimed(user));
    }
}
