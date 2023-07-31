// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract MoodNft is ERC721{
    //ERRORS
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;
    
    enum Mood {
        HAPPY,
        SAD
    }
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageURI,
    string memory happySvgImageURI) ERC721 ("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = sadSvgImageURI;
        s_happySvgImageURI = happySvgImageURI;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY; //default mood as happy
        s_tokenCounter++;
    }
    
    function flipMood(uint256 tokenId) public {
        //only want NFT owner to be able to change the mood
       if (_isApprovedOrOwner(msg.sender, tokenId)) {
        revert MoodNft__CantFlipMoodIfNotOwner();
       }
       if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
        s_tokenIdToMood[tokenId] == Mood.SAD;
       } else {
        s_tokenIdToMood[tokenId] == Mood.HAPPY;
       }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data: application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageURI;
        } else {
            imageURI = s_sadSvgImageURI;
        }


        //wrapping the whole thing up in the base64 to return a string that we can insert into search bar and get the image
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}