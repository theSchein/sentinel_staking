pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Sentinel
 * @dev Accepts deposits, becomes PIC, after a time period it exits its position and sends returns to users
 */
import {TOGA} from "@superfluid-finance/protocol-monorepo/packages/ethereum-contracts/contracts/utils/TOGA.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import {vestingShares} from "vestingShares.sol

 contract Sentinel {

    // calling SafeMath will add extra functions to the uint data type
    using SafeMath for uint; // you can make a call like myUint.add(123)


    // TODO: set some static variables
     address payable TOGA = 0x6AEAeE5Fd4D05A741723D752D30EE4D72690A8f7;

     //uint public vestTime; // temporarily removed

     // scope of tghe PIC is just ricochet token at this point
     ERC20 ric = ERC20("0x263026E7e53DBFDce5ae55Ade22493f828922965")


    // when you can withdraw is saved in lockTime
    mapping(address => uint) public lockTime;

    function deposit(uint amount) public {

        ric.transferFrom(msg.sender, address(this), amount);

        // store account and amount sent to it
        mint(msg.sender, amount); // Does transfer too
        // msg.sender.send()

        // Becomes PIC if it can afford it
        if (address(this).balance > (TOGA.balance) * 1.1 ) {
            // set variable here to reuse in withdraw
            ric.balanceOf(address(this));

            TOGA.send( ric.balanceOf(address(this)) );

            // lockTime[msg.sender] = block.timestamp + 90 days;

        }
    }

    function withdraw() public {
        // after the given time is up, unstake from the PIC contract and allow withdraws
        // check that the now time is > the time saved in the lock time mapping


        // require(block.timestamp > lockTime[msg.sender], "lock time has not expired"); TEMPORARILY REMOVED

        //TODO: FIGURE OUT HOW TO UNSTAKE
        // it takes up to 7 days to pull out the the full initial stake.
        changeExitRate(ric.address, getMaxExitRate(ric.address, stakeAmount));


        //check PIC status
        if (function getCurrentPIC(Ric) =! address(this)) {


            // send the ether back to the sender, share tokens are worth more than deposit tokens.
            tokenValue = ric.balanceOf(address(this)) / ERC20.totalSupply()
            ric.balanceOf(msg.sender)
        }


    }

    function emergencyWithdraw(ERC20 token, uint amount) external onlyOwner {
        token.transfer(owner()), amount)
    }



 }
