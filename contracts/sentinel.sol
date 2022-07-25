// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Sentinel
 * @dev Accepts deposits gives depositor a token in return. When the threshold
 * to become PIC is reached, this contract transfers the funds to the TOGA contract.
 * After a given timeperiod the contract unstakes until it is no longer the PIC.
 * At that point the contract will allow for exchanging the shares for a its funds/profit.
 */

import "@openzeppelin/contracts/utils/Context.sol";
import {TOGA} from "@superfluid-finance/ethereum-contracts/contracts/utils/TOGA.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

 contract Sentinel is ERC20Burnable, Ownable {


    address toga = 0x6AEAeE5Fd4D05A741723D752D30EE4D72690A8f7;

    // scope of the PIC is just ricochet token at this point
    ISuperToken ric = ISuperToken(0x263026E7e53DBFDce5ae55Ade22493f828922965);

    uint256 stakeAmount;

    bool withdrawable = false;

    uint shareValue;



    // when you can withdraw is saved in lockTime
    mapping(address => uint) public lockTime;

    //amount staked to address
    mapping(address => uint) public stake;

    // ERC20 token to reperesent shares of this contract investment
    constructor() ERC20("stonks", "STNK") {}

    // This function takes Ricochet tokens and returns share tokens to the investor
    // if the threshold is reached, the contract then becomes PIC.
    function deposit(uint amount) public {

        require(TOGA(toga).getCurrentPIC(ric) != address(this), "Already PIC, not accepting more capital");

        // store account and amount sent to it
        stake[msg.sender] = amount;

        // issue erc20 shares of token to the investor
        _mint(msg.sender, amount);


        // Transfer ric token from user to contract
        ric.transferFrom(msg.sender, address(this), amount);

        // Becomes PIC if it can afford it
        if (ric.balanceOf(address(this)) > (ric.balanceOf(toga)) ) {
            // set variable here to reuse in withdraw
            stakeAmount = ric.balanceOf(address(this));

            ISuperToken(ric).transfer(toga, ric.balanceOf(address(this))); //send( toga, ric.balanceOf(address(this)), "0x" );
            // Setting up the timelock
            lockTime[address(this)] = block.timestamp + 2 days;  //2 days for testing 90 days for production

        }
    }


    // After the given time is up, unstake from the PIC contract and allow withdraws
    // check that the now time is > the time saved in the lock time mapping
    function unstake() public {

        // blocks function if timelock is not up
        require(block.timestamp > lockTime[address(this)], "lock time has not expired");

        // it takes up to 7 days to pull out the the full initial stake.
        TOGA(toga).changeExitRate(ric, TOGA(toga).getMaxExitRateFor(ric, ric.balanceOf(address(toga))));


        //check PIC status
        if (TOGA(toga).getCurrentPIC(ric) != address(this)) {

            withdrawable = true;
            // send the ether back to the sender, share tokens are worth more than deposit tokens.
            shareValue = ric.balanceOf(address(this)) / ERC20.totalSupply();

        }
    }
    // executor can redem thier shares for the original investment + profit
    function withdraw(uint amount) public payable {

        // Requires you to both have shares and for it to be withdrawable
        require(balanceOf(msg.sender) > 0, "You have sent no shares to redeem" );
        require(withdrawable == true, 'You are not able to withdraw your funds yet');

        // Gives capital + profit back to share holder and then burns the shares. 
        ric.transferFrom(address(this), msg.sender, amount * shareValue);
        burn(amount);

    }

// EMERGENCY RUGPULL FEATURE: This is in for emergency testing on mainnet, it will be removed before I actually try to get people to use this
    function emergencyWithdraw(IERC20 token, uint amount) external onlyOwner {
        token.transfer(owner(), amount);
    }



 }
