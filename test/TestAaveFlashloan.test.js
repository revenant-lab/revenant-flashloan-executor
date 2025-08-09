import { expect } from "chai";
import { ethers } from "hardhat";

// Use a real address of a borrowable token from Aave V3
const TOKEN_TO_FLASHLOAN = "0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8"; // USDC on Arbitrum

describe("TestAaveV3Flashloan", function () {
  let flashloanContract;

  beforeEach(async () => {
    const [deployer] = await ethers.getSigners();

    const providerAddr = "0xa97684ead0e402dc232d5a977953df7ecbab3cdb"; // Arbitrum Aave V3
    const Flashloan = await ethers.getContractFactory("TestAaveV3Flashloan");
    flashloanContract = await Flashloan.deploy(providerAddr);
    await flashloanContract.waitForDeployment();
  });

  it("should request and repay a flashloan", async () => {
    const amount = ethers.parseUnits("1000", 6); // 1,000 USDC

    const tx = await flashloanContract.requestFlashLoan(TOKEN_TO_FLASHLOAN, amount);
    const receipt = await tx.wait();

    console.log("✅ Flashloan transaction hash:", receipt.hash);

    expect(receipt.status).to.equal(1);
  });
});

