// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract MyToken is ERC20, Ownable, ERC721Holder{
    IERC721 public nft;
    mapping(uint256 => address) public tokenOwnerOf;
    mapping(uint256=> uint256) public tokenStakedAt;
    uint256 public Emission_rate = (50*  10 ** decimals())/1 days;

    constructor (address _nft) ERC20("MyToken", "MNFT"){
        nft = IERC721(_nft);
    }

    function stake(uint256 tokenId) external {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        tokenOwnerOf[tokenId] = msg.sender;
        tokenStakedAt[tokenId] = block.timestamp;
    }
    
    function calculateTokens(uint256 tokenId) public view returns (uint256) {
        uint256 timeElapsed = block.timestamp - tokenStakedAt[tokenId];
        return (timeElapsed * Emission_rate);
    }
    
    function unstake(uint256 tokenId) external {
        require(tokenOwnerOf[tokenId] == msg.sender, "Can't unstake this NFT. You are not the owner.");
        _mint(msg.sender, calculateTokens(tokenId));
        nft.transferFrom(address(this), msg.sender, tokenId);
        delete tokenOwnerOf[tokenId];
        delete tokenStakedAt[tokenId];
    }
}

//0x420B1Af8C84d7082acE9cAD30488F265F592C006