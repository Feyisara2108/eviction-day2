// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/core/AresTreasury.sol";

contract DeployAresTreasury is Script {
    function run() external {
        address[] memory signers = new address[](2);
        signers[0] = vm.envAddress("SIGNER1");
        signers[1] = vm.envAddress("SIGNER2");

        vm.startBroadcast();

        new AresTreasury(signers);

        vm.stopBroadcast();
    }
}
