# Sentinal Staking Pool

Pool capital to run a superfluid sentinel as a PIC. This will generate yields that will be returned to those that sent capital to the contract.

## How it works

1. Ethereum accounts fund the sentinel staker contract
2. Ethereum accounts are issued 'sentinel tokens' as shares of the returns
3. After contract raises set capital to be PIC, funding closes and no more tokens are issued
4. Contract makes call method to become PIC
5. Contract makes liquidations by using the host.closestream()
6. Liquidation profits are distributed as tokens to funders
7. After time period the PIC role is unstaked
8. Funder tokens can be redeemed for profits from Sentinel contract


## Parameters

- fundingAmount: Hard coded max value to capital raised to the contract, (1.5xish for PIC of each)
- tokenContract: hardcoded currency contract for the PIC and token (ricochet)
- timePeriod: hardcoded time for contract duration (like a month)

## Methods

- updatePIC(): method to send capital required to become PIC
	- token.send(stake) -> TOGA contract

- liquidate(): method to close streams as PIC needs (token, account)
	- proxy to host CFA
	- liquidate command from abi

- distribute(): method to distribute profit for tokens



## liquidation hack
  generateMultiDeleteFlowABI (superToken, senders, receivers) {
    try {
      return this.app.client.batch.methods.deleteFlows(
        this.app.client.sf._address,
        this.app.client.CFAv1._address,
        superToken,
        senders,
        receivers
      ).encodeABI();
    } catch (err) {
      this.app.logger.error(err);
      throw Error(`Protocol.generateMultiDeleteFlowABI() : ${err}`);
    }
  }




## Contracts
- https://polygonscan.com/address/0x6AEAeE5Fd4D05A741723D752D30EE4D72690A8f7
 
