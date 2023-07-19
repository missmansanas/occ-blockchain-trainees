//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyNFT is ERC721URIStorage {
    uint public boxPrice = 0.001 ether;
    uint public maxItems = 20;

    constructor() ERC721("MyNFT", "MNFT") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmPmANdk3gcFdvt3J8Sw1y2Z7tv3LpvKxkwdjb1oMVLNmn/";
    }

    function tokenURI (uint256 tokenID) public view virtual override returns (string memory) {
            string memory baseURI = _baseURI();

            return bytes(baseURI).length > 0 ?
                string(abi.encodePacked(baseURI, Strings.toString(tokenID), ".json")) : "";
        }

    function openBox()public payable {
        require(msg.value == boxPrice, "Send the correct amount to buy a loot box.");
        
        uint256 randomTokenId = (uint256(keccak256(abi.encode(block.timestamp, msg.sender))) % maxItems) + 1;
        mintEquipment(tokenURI(randomTokenId), randomTokenId);
    }

    function mintEquipment(string memory _tokenURI, uint tokenId) internal returns(uint256) {
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }
}