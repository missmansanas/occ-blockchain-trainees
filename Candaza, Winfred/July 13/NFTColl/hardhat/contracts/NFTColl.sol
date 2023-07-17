// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract MyNftColl is ERC721Enumerable, Ownable {
    using Strings for uint256; 
        string _baseTokenURI; //stores the base URI for token metadata
        uint256 public _price = 0.01 ether; //sotres the price for minting nft
        bool public _paused; //indicates wether the contract is paused
        uint256 public maxTokenIds = 20; //stires the maximum number of NFTs that can be minted
        uint256 public tokenIds; //counter that keeps tract of the number of NFTs that have minted 

//used to restrict certain funtions from executing when the contract is in a paused state
        modifier onlyWhenNotPaused() {
            require(!_paused, "Contract currently paused.");
            _;
        }

        constructor(string memory baseURI) ERC721("NFTCall", "NFTCOLL") {
            _baseTokenURI = baseURI;
        }

//allows the user to mint an NFT
        function mint() public payable{
            require(tokenIds < maxTokenIds, "Exceeded maximum NFTColl supply");
            require(msg.value >= _price, "Ether is not correct.");
            tokenIds += 1;
            _safeMint(msg.sender, tokenIds);
        }

//overrides the ERC721 implementation
//returns the baseURI for the token metadata
        function _baseURI() internal view virtual override returns(string memory){
            return _baseTokenURI;
        }

//returns specific URI for a given tokenIDm concatenating the base URI, tokenID and json fole extension
        // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        //     require(_exists(tokenId), "ERC721Metada: URI query for nonexistent token");
        //     string memory baseURI = _baseURI();
        //     return bytes(baseURI).length > 0?
        //         string(abi.encodePacjed(baseURI, tokenId.toString(), "json")) : "";
        // }

        function tokenURI (uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
            string memory baseURI = _baseURI();
            
            return bytes(baseURI).length > 0 ? 
                string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
        }



//allows the contract owner to pause or unpause the contract
        function setPaused (bool val) public onlyOwner {
            _paused = val;
        }

//used to withdraw all of the Ether from the contract. 
//allows the contract owner to withdraw the contract's balance
        function withdraw() public onlyOwner {
            address _owner = owner();
            uint256 amount = address(this).balance;
            (bool sent, ) = _owner.call{value:amount}("");
            require(sent, "failed to send Ether");
        }

//called when ether is sent to the contract
        receive() external payable {}

//called when the contract is called wiithout a function name
        fallback() external payable {}
}
//ipfs://QmPVW7jYu49pc51p3qAC8VFSBUUreXtevKsVhwLoW25haz/1