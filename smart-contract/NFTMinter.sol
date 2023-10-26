// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMinter is ERC721URIStorage, Ownable {
    uint256 private tokenIdCounter;
    uint256 public nextTokenId;
    uint256 public royaltyPercentage;
    address public treasuryWallet;
    address public liquidityWallet;

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _royaltyPercentage , 
        address _liquidityWallet, 
        address _treasuryWallet
    ) ERC721(_name, _symbol) Ownable(msg.sender) { 
        nextTokenId = 1; 
        royaltyPercentage = _royaltyPercentage; 
        liquidityWallet = _liquidityWallet; 
        treasuryWallet = _treasuryWallet; 
    }

    function mintNFT(string memory _tokenURI, uint256 _price) external payable {
        require(_price > 0, "Price Must Be Greater Than 0 ");
        require(msg.value >= _price, "Insufficient Funds");

        uint256 tokenId = nextTokenId;
        nextTokenId++;

        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        uint256 royaltyAmount = (_price * royaltyPercentage) / 100;
        uint256 liquidityAmount = (_price * (10 - royaltyPercentage)) / 100;

        (bool success, ) = treasuryWallet.call{value: royaltyAmount}("");
        require(success, "Treasury Wallet Transfer Failed");

        (success, ) = liquidityWallet.call{value: liquidityAmount}("");
        require(success, " Liquidity Wallet Transfer Failed");
    }
}

