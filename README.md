# Sentinal Staking Pool

This contract works to pool capital to run a superfluid sentinel as a Patrician-In-Command (PIC). This role allows for first access on liquidating continous superfluid streams that have become insolvent. By performing these liquidations the contract will generate returns that will be returned to those that sent capital to the contract, along with thier initial investment after a specified investment period.

## How it works

1. Polygon accounts fund the sentinel staker contract 
2. These investor  accounts are issued 'shares' in return for thier capital in the form of ERC-20 tokens
3. After contract raises the threshold capital to be PIC, funding closes and no more tokens are issued
4. Contract sends funds to the TOGA contract to become PIC
5. An operator runs the required back-end sentinal software, setting the contract address as the PIC and performing liquidations
6. After a set time period contract makes a call to exit out of the PIC postion
7. When the contract is no longer PIC it has all the initial capital + the liquidation fees collected
8. The 'share' tokens are redeemable from the contract at a exchange rate that includes the profit


## Parameters

- stakeAmount: Amount needed to raise to become the PIC, it varies depending on the competition for the role
- token contract: hardcoded super token contract for token the contract is running on (ricochet)
- lockTime: time period in which the capital is locked into being the PIC (3 months) 

## Current Status

- Proof of concept contract deployed on polygon mainnet
- sentinel service running on cloud computer with contract address

## TODO:

- Further testing of contract on mainnet (low stakes amounts)
- flesh out application frontend 
- Implement time lock features and ERC-20 token share minting
- Expand to more L2s and stream markets
- Make a DAO that goes to the moon 


## Deployed Contract
- https://polygonscan.com/address/0x243aBbf7BBCF4BA482b395ce84c4B32f35a4BB31
 
## PIC and TOGA Page
https://toga.superfluid.finance/

# sentinel_staking
