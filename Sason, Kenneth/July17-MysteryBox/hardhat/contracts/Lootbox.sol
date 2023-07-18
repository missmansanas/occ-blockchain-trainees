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
        return "ipfs://QmXQkwr8gVyg2rMxjnZb6znhvn4Y7rUwUWy5nwwGgprVrz/";
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
        require(boxes[msg.sender] > 0, "YOu must have a lootbox");
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
//https://mumbai.polygonscan.com/address/0x6bf0946e8b22c5a38de2bdac30f01448102903fb
//https://mumbai.polygonscan.com/address/0xB6F6BA2A175c9645c5E569aA560d391fB7A2fAea#writeContract
//https://testnets.opensea.io/0x12B4279548706B0428AE3ccf8E155CC7020e86d4
//0xf06619E05Ee2e7b260727B68193b69c981C05827
