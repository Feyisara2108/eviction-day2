// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/core/AresTreasury.sol";

contract DeployAresTreasury is Script {
    function run() external {
        address[] memory signers = new address[](2);
        signers[0] = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        signers[1] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

        vm.startBroadcast();

        new AresTreasury(signers);

        vm.stopBroadcast();
    }
}
