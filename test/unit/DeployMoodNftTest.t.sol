// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public view {
        string memory expectedURI = "data:image/svg+xml;base64,PHN2ZyB4bWxucyA9ICJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGggPSAiNTAwIiBoZWlnaHQgPSAiNTAwIj4KPHRleHQgeCA9ICIwIiB5ID0gIjE1IiBmaWxsID0gImJsYWNrIj4gSGkhIFlvdXIgYnJvd3NlciBkZWNvZGVkIHRoaXMhIDwvdGV4dD4KPC9zdmc+Cgo=";
        string memory svg = '<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"500\" height=\"500\"><text x=\"0\" y=\"15\" fill=\"black\"> Hi! Your browser decoded this! </text></svg>';
        string memory actualUri = deployer.svgToImageURI(svg);
        assert(keccak256(abi.encodePacked(actualUri)) == keccak256(abi.encodePacked(expectedURI)));
    }
}