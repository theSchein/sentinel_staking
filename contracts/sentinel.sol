pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Sentinel
 * @dev Accepts deposits, becomes the superfluid PIC, after a time period it exits
 * its position and sends money back to investors
 */
import {TOGA} from "@superfluid-finance/ethereum-contracts/contracts/utils/TOGA.sol";
import {ISuperToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import {vestingShares} from "./vestingShares.sol";  //temporarily removed

 contract Sentinel is Ownable {

    address toga = 0x6AEAeE5Fd4D05A741723D752D30EE4D72690A8f7;

     //uint public vestTime; // temporarily removed

     // scope of tghe PIC is just ricochet token at this point
    ISuperToken ric = ISuperToken(0x263026E7e53DBFDce5ae55Ade22493f828922965);
    uint256 stakeAmount;

    // when you can withdraw is saved in lockTime
    //mapping(address => uint) public lockTime;

    function deposit(uint amount) public {

        ric.transferFrom(msg.sender, address(this), amount);

        // store account and amount sent to it

        //mint(msg.sender, amount); // Does transfer too OUTSIDE OF TEST SCOPE
        // msg.sender.send()

        // Becomes PIC if it can afford it
        if (ric.balanceOf(address(this)) > (ric.balanceOf(toga)) ) {
            // set variable here to reuse in withdraw
            stakeAmount = ric.balanceOf(address(this));

            ISuperToken(ric).send( toga, ric.balanceOf(address(this)), "0x" );

            // lockTime[msg.sender] = block.timestamp + 90 days;

        }
    }

    function withdraw() public {
        // after the given time is up, unstake from the PIC contract and allow withdraws
        // check that the now time is > the time saved in the lock time mapping


        // require(block.timestamp > lockTime[msg.sender], "lock time has not expired"); TEMPORARILY REMOVED

        //TODO: FIGURE OUT HOW TO UNSTAKE
        // it takes up to 7 days to pull out the the full initial stake.
        TOGA(toga).changeExitRate(ric, TOGA(toga).getMaxExitRateFor(ric, stakeAmount));


        //check PIC status
        if (TOGA(toga).getCurrentPIC(ric) != address(this)) {


            // send the ether back to the sender, share tokens are worth more than deposit tokens.
            // tokenValue = ric.balanceOf(address(this)) / ERC20.totalSupply() OUTSIDE SCOPE
            ric.transfer(msg.sender, ric.balanceOf(address(this)));
            //ric.balanceOf(msg.sender);

        }


    }

    function emergencyWithdraw(IERC20 token, uint amount) external onlyOwner {
        token.transfer(owner(), amount);
    }



 }
