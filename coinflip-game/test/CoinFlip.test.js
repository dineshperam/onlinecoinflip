const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CoinFlip Contract", function () {
  let Token, token, CoinFlip, coinFlip, owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    Token = await ethers.getContractFactory("ERC20Mock");
    token = await Token.deploy("TestToken", "TTK", owner.address, ethers.utils.parseEther("10000"));
    await token.deployed();

    CoinFlip = await ethers.getContractFactory("CoinFlip");
    coinFlip = await CoinFlip.deploy(token.address);
    await coinFlip.deployed();

    // Transfer some tokens to addr1
    await token.transfer(addr1.address, ethers.utils.parseEther("1000"));
  });

  it("Should allow a user to place a bet and potentially win", async function () {
    const betAmount = ethers.utils.parseEther("10");
    await token.connect(addr1).approve(coinFlip.address, betAmount);
    
    await expect(coinFlip.connect(addr1).placeBet(betAmount, 0))
      .to.emit(coinFlip, 'BetPlaced');
    
    // Check contract balance
    const contractBalance = await token.balanceOf(coinFlip.address);
    expect(contractBalance).to.equal(betAmount);
  });

  // Add more tests for winning and losing scenarios
});
