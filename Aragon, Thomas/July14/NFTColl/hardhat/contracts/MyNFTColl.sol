// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyNFTColl is ERC721Enumerable, Ownable {
    using Strings for uint256;
        string _baseTokenURI;
        uint256 public _price = 0.01 ether;
        bool public _paused;
        uint256 public maxTokenIds = 20;
        uint256 public tokenIds;

        modifier onlyWhenNotPaused() {
            require(!_paused, "Contract currently paused.");
            _;
        }

        constructor(string memory baseURI) ERC721("NFTColl", "NFTCOLL"){
            _baseTokenURI = baseURI;
        }

        function mint() public payable {
            require(tokenIds <= maxTokenIds, "Exceeded maximum NFTColl supply.");
            require(msg.value >= _price, "Ether is not correct.");
            tokenIds +=1;
            _safeMint(msg.sender, tokenIds);
        }

        function _baseURI() internal view virtual override returns (string memory){
            return _baseTokenURI;
        }

        function tokenURI (uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
            string memory baseURI = _baseURI();

            return bytes(baseURI).length > 0 ?
                string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
        }

        function setPaused(bool val) public onlyOwner {
            _paused = val;
        }

        function withdraw() public onlyOwner {
            address _owner = owner();
            uint256 amount = address(this).balance;
            (bool sent, ) = _owner.call {value: amount}("");
            require(sent,"Failed to send Ether.");
        }

        receive() external payable {}

        fallback() external payable {}
}

// ipfs://QmQUTJkE3irEGCpBdPkEAFzdb23fmjBG1Vv84SQMN3khaD/1

// 0xdB6e5822071eD4e01163253E6E06D8C86Da8147c