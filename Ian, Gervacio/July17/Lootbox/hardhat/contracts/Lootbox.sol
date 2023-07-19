// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Lootbox is ERC721URIStorage {
    uint public boxPrice = 0.001 ether; //Price of a single Lootbox
    uint public maxItems = 20; // maximum number of items that can be minted from the lootbox
    mapping(address => uint) public boxes;
    constructor() ERC721("Lootbox", "LBG") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmZL6wU2TDubm1yiPKM4H2VE63tNs3mTPLiDz84tbqneyd/";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        baseURI,
                        Strings.toString(tokenId),
                        ".json"
                    )
                )
                : "";
    }

    function buyBox() public payable {
        require(
            msg.value == boxPrice,
            "Send the correct amount to buy a lootbox"
        );
        boxes[msg.sender]++;
    }

    function openBox() public {
        require(boxes[msg.sender] > 0, "You must have a lootbox");
        boxes[msg.sender]--;
        uint256 randomTokenId = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        ) % maxItems;
        mintEquipment(tokenURI(randomTokenId), randomTokenId);
    }
    
    function mintEquipment(
        string memory _tokenURI,
        uint tokenId
    ) internal returns (uint256) {
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }
}

//0xE92e793fB6d660b75c033fce19f1c03F98051D69
//0xd87A1955F0039F4DE469fc4d4e6206d67a66a8A3
//0x3C4C123813C79E220247B634217460e2C923aeE6
//0x912B2f3a919373aAFF825C17E7f51fC82F551A8b