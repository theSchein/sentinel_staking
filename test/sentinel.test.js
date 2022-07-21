const { expect } = require("chai");
const { ethers } = require("hardhat");
const SuperfluidSDK = require("@superfluid-finance/js-sdk");
const Web3 = require("web3")
const web3 = new Web3("http://localhost:8545")

// run with npx hardhat run test/sentinel.test.js --network matic

let togaAddress = "0x6AEAeE5Fd4D05A741723D752D30EE4D72690A8f7";
let aliceAddress = "0xBedE99308C1ef78bCd2953fcA90b508c3B0A0fc0" //"0xD85ed7c6E8fDB11f2FCE874013320cCf50a341Ad"; // a wallet with a lot of RIC and some MATIC
let alice;
let ricAddress = "0x263026E7e53DBFDce5ae55Ade22493f828922965";
let ric;
let toga;
let sf;
let sentinel;

describe("Sentinel", function () {

  before(async function() {

    // Make Alice
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [aliceAddress],}
    );
    alice = await ethers.getSigner(aliceAddress);

    const Sentinel = await ethers.getContractFactory("Sentinel");
    sentinel = await Sentinel.deploy();
    await sentinel.deployed();
    console.log('Sentinel deployed to:', sentinel.address);

    const ERC20 = await ethers.getContractFactory("ERC20");
    ric = await ERC20.attach(ricAddress);

    const TOGA = await ethers.getContractFactory("TOGA");
    toga = await TOGA.attach(togaAddress);

    sf = new SuperfluidSDK.Framework({
        web3,
        resolverAddress: "0xE0cc76334405EE8b39213E620587d815967af39C",
        tokens: ["WBTC", "DAI", "USDC", "ETH"],
        version: "v1"
    });
    await sf.initialize();

  })

  it("should deposit and become pic", async function () {
    let aliceBal = await ric.balanceOf(alice.address);
    let togaBal = await ric.balanceOf(toga.address);
    await ric.connect(alice).approve(sentinel.address, aliceBal);
    await sentinel.connect(alice).deposit(aliceBal);

    //// Expect the RIC was properly deposited to the TOGA contract
    // Alice sent all her RIC to sentinel
    expect(await ric.balanceOf(alice.address)).to.equal(0);
    // Sentinel sent all its RIC to TOGA
    expect(await ric.balanceOf(sentinel.address)).to.equal(0);
    // Toga has all the RIC from alice
    expect(await ric.balanceOf(toga.address)).to.not.equal(togaBal);

    //// Expect that the sentinel is the PIC
    console.log(await toga.getCurrentPIC(ric.address));
    expect(await toga.getCurrentPIC(ric.address)).to.equal(sentinel.address);

  });

  it("should unstake toga", async function (){
    

  });

  it("should withdraw funds"), async function () {

  }
});
