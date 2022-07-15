// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
/**
 * @title Vesting Shares
 * @dev ERC20 tokens created and issued as a share of the sentinal
 */
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract vestingShares is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("stonks", "STNK") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
