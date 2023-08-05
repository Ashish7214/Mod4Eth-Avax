// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    struct Item {
        uint256 itemId;
        string name;
    }

    mapping(uint256 => uint256) private _itemPrices;
    mapping(address => mapping(uint256 => uint256)) private _playerPrizes;
    mapping(uint256 => Item) private _availableItems;

    constructor() ERC20("Degen", "DGN") {
      
    }

    function mint(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }

    function setItemPrice(uint256 itemId, uint256 price) public onlyOwner {
        _itemPrices[itemId] = price;
    }

    function getItemPrice(uint256 itemId) public view returns (uint256) {
        return _itemPrices[itemId];
    }

    function redeem(uint256 itemId) public {
        uint256 price = _itemPrices[itemId];
        require(price > 0, "Invalid item price");
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem");

        _transfer(msg.sender, address(this), price);
        _playerPrizes[msg.sender][itemId] += 1;

        // Grant the in-game item to the player here
        _availableItems[itemId] = Item(itemId, "Item Name");
        emit ItemRedeemed(msg.sender, itemId, price);
    }

    function getPlayerPrizes(address player, uint256 itemId) public view returns (uint256) {
        return _playerPrizes[player][itemId];
    }

    function burn(uint256 amount) public {
        require(amount > 0, "Invalid amount");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");

        _burn(msg.sender, amount);
    }

    event ItemRedeemed(address indexed player, uint256 itemId, uint256 price);
}
