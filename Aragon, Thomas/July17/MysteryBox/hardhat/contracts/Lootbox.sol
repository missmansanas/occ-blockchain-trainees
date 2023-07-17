//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Lootbox is ERC721URIStorage {
    uint public boxPrice = 0.001 ether;
    uint public maxItems = 20;

    mapping (address => uint) public boxes;

    constructor() ERC721("Lootbox", "LBG") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmPmANdk3gcFdvt3J8Sw1y2Z7tv3LpvKxkwdjb1oMVLNmn/";
    }

    function tokenURI (uint256 tokenID) public view virtual override returns (string memory) {
            string memory baseURI = _baseURI();

            return bytes(baseURI).length > 0 ?
                string(abi.encodePacked(baseURI, Strings.toString(tokenID), ".json")) : "";
        }

    function buyBox()public payable {
        require(msg.value == boxPrice, "Send the correct amount to buy a loot box.");

        boxes[msg.sender]++;
    }

    function openBox() public {
        require(boxes[msg.sender] > 0, "You must own a loot box to open one.");
        boxes[msg.sender]--;

        uint256 randomTokenId = uint256 (keccak256(abi.encodePacked(block.timestamp, msg.sender))) % maxItems;
        mintEquipment(tokenURI(randomTokenId), randomTokenId);
    }

    function mintEquipment(string memory _tokenURI, uint tokenId) internal returns(uint256) {
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }
}

// 0x19F031ee1eA4C3B618A8a16B4DEe95b70295194f