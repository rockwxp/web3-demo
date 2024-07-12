// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";

contract NFT_Market is IERC721Receiver, IERC1363Receiver {
    IERC20 public immutable tokenContract;
    IERC721 public immutable nftContract;

    constructor(address rockToken, address RockNft) {
        tokenContract = IERC20(rockToken);
        nftContract = IERC721(RockNft);
    }

    struct NFT {
        uint256 tokenId;
        uint256 price;
        address owner;
    }
    mapping(uint256 => NFT) public nfts;

    event NFTListed(uint256 tokenId, uint256 price, address owner);

    error NotEnoughMoney(uint256 tokenId, uint256 price, address buyer);

    event NFTSold(
        uint256 tokenId,
        uint256 price,
        address seller,
        address buyer
    );

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        uint256 price = abi.decode(data, (uint256));
        nfts[tokenId] = NFT(tokenId, price, from);
        emit NFTListed(tokenId, price, from);

        return IERC721Receiver.onERC721Received.selector;
    }
    event startTransferNFT(address nftMarket, address buyer, uint256 tokenId);
    event startTransferToken(address nftMarket, address owner, uint256 value);
    function onTransferReceived(
        address operater,
        address to,
        uint256 amount,
        bytes memory data
    ) external returns (bytes4) {
        uint256 tokenId = abi.decode(data, (uint256));
        address owner = nfts[tokenId].owner;
        uint256 price = nfts[tokenId].price;
        delete nfts[tokenId];

        if (amount == price) {
            emit startTransferNFT(address(this), operater, tokenId);
            nftContract.safeTransferFrom(address(this), operater, tokenId);

            emit startTransferToken(address(this), owner, amount);
            tokenContract.transfer(owner, amount);
        } else if (amount > price) {
            tokenContract.transferFrom(address(this), to, amount - price);
        } else {
            revert NotEnoughMoney(tokenId, price, to);
        }

        require(amount >= nfts[tokenId].price, "amount should more than 0");

        return IERC1363Receiver.onTransferReceived.selector;
    }
}
