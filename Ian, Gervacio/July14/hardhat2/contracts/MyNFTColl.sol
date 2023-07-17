// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyNFTColl is ERC721Enumerable, Ownable {
    using Strings for uint256;
        string _baseTokenURI; //stores the base URI for token metadata
        uint256 public _price = 0.01 ether; //stores the price for minting an NFT
        bool public _paused; // indicates wether the contract is paused
        uint256 public maxTokenIds = 20; //stores the maximum number of NFTs that can be minted
        uint256 public tokenIds; //counter that keeps tract of the number of NFTs that have been minted

//used to restrict certain functions from executing when the contract is in a paused state
        modifier onlyWhenNotPaused() {
            require(!_paused, "Contract currently paused");
            _;
        }

        constructor(string memory baseURI) ERC721("NFTColl", "NFTCOLL") {
            _baseTokenURI = baseURI;
        }

//allows the user to mint an NFT 
        function mint() public payable onlyWhenNotPaused {
            require(tokenIds < maxTokenIds, "Exceeded maximum NFTColl supply");
            require(msg.value >= _price, "Ether sent is not correct");
            tokenIds += 1;
            _safeMint(msg.sender, tokenIds);
        }

//overrides the ERC721 implementation 
//returns the base URI for the token metadata
        function _baseURI() internal view virtual override returns (string memory) {
            return _baseTokenURI;
        }

//returns specific URI for a given tokenID, concatenating the base URI, tokenID and json file extension
        function tokenURI (uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
            string memory baseURI = _baseURI();
            
            return bytes(baseURI).length > 0 ? 
                string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
        }

//allows the contract owner to pause or unpause the contract
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

//used to withdraw all of the Ether from the contract. 
//Allows the contract owner to withdraw the contract's balance
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

//called when ether is sent to the contract
    receive() external payable {}

//called when the contract is called without a function name
    fallback() external payable {}
}

//0x93A52C989603384ed6B7dbD28032706737CF1DC5

//0x32b705f0c1E6BBE5f7BCf33F83401D010669f13d