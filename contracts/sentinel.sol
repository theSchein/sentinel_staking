// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Sentinel
 * @dev Accepts deposits, becomes the superfluid PIC, after a time period it exits
 * its position and sends money back to investors
 */

import "@openzeppelin/contracts/utils/Context.sol";
import {TOGA} from "@superfluid-finance/ethereum-contracts/contracts/utils/TOGA.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {vestingShares} from "./vestingShares.sol";  

 contract Sentinel is Ownable, vestingShares {

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

    function deposit(uint amount) public {

        require(TOGA(toga).getCurrentPIC(ric) != address(this), "Already PIC, not accepting more capital");

        // store account and amount sent to it
        stake[msg.sender] = amount;

        // issue erc20 shares of token to the investor
        mint(msg.sender, amount);


        // Transfer ric token from user to contract
        ric.transferFrom(msg.sender, address(this), amount);

        // msg.sender.send()

        // Becomes PIC if it can afford it
        if (ric.balanceOf(address(this)) > (ric.balanceOf(toga)) ) {
            // set variable here to reuse in withdraw
            stakeAmount = ric.balanceOf(address(this));

            ISuperToken(ric).send( toga, ric.balanceOf(address(this)), "0x" );

            lockTime[address(this)] = block.timestamp + 2 days;  //2 days for testing 90 days for production

        }
    }

    function unstake() public {
        // after the given time is up, unstake from the PIC contract and allow withdraws
        // check that the now time is > the time saved in the lock time mapping


        require(block.timestamp > lockTime[address(this)], "lock time has not expired");

        //TODO: FIGURE OUT HOW TO UNSTAKE
        // it takes up to 7 days to pull out the the full initial stake.
        TOGA(toga).changeExitRate(ric, TOGA(toga).getMaxExitRateFor(ric, ric.balanceOf(address(toga))));


        //check PIC status
        if (TOGA(toga).getCurrentPIC(ric) != address(this)) {

            withdrawable = true;
            // send the ether back to the sender, share tokens are worth more than deposit tokens.
            shareValue = ric.balanceOf(address(this)) / ERC20.totalSupply(); //OUTSIDE SCOPE
            
            
            //ric.transfer(msg.sender, ric.balanceOf(address(this))); //currently only set up for one funder

        }
    }

    function withdraw(uint amount) public payable{
        // executor can redem thier shares for the original investment + profit
        require(ERC20.balanceOf(msg.sender) > 0, "You have no shares to redeem" );


        ric.transferFrom(address(this), msg.sender, amount * shareValue);


        
    }

    function emergencyWithdraw(IERC20 token, uint amount) external onlyOwner {
        token.transfer(owner(), amount);
    }



 }
