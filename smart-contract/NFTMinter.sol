// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMinter is ERC721URIStorage, Ownable {
    uint256 private tokenIdCounter;

    constructor(address initialOwner) ERC721("MyNFT", "NFT") Ownable(initialOwner) {}

    function mintNFT(address recipient, string memory tokenURI) external onlyOwner {
        uint256 tokenId = tokenIdCounter;
        tokenIdCounter += 1;
        _mint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
}

