import { ethers } from "hardhat";

// Aave V3 PoolAddressesProvider addresses by network
const AAVE_POOL_ADDRESS_PROVIDER = {
  mainnet: "0xb53c1a33016b2dc2ff3653530bff1848a515c8c5",
  arbitrum: "0xa97684ead0e402dc232d5a977953df7ecbab3cdb",
  localhost: "0x0000000000000000000000000000000000000000" // Replace for fork if needed
};

const TARGET_NETWORK = process.env.NETWORK || "arbitrum"; // default to arbitrum

async function main() {
  const [deployer] = await ethers.getSigners();

  const providerAddress = AAVE_POOL_ADDRESS_PROVIDER[TARGET_NETWORK];
  if (!providerAddress) {
    throw new Error(`No Aave Pool Provider for network: ${TARGET_NETWORK}`);
  }

  console.log(`🚀 Deploying TestAaveV3Flashloan on ${TARGET_NETWORK}`);
  console.log(`👤 Deployer: ${deployer.address}`);
  console.log(`🏦 Aave Provider: ${providerAddress}`);

  const Factory = await ethers.getContractFactory("TestAaveV3Flashloan");
  const contract = await Factory.deploy(providerAddress);

  await contract.waitForDeployment();
  const deployedAt = await contract.getAddress();

  console.log(`✅ Contract deployed at: ${deployedAt}`);
}

main().catch((err) => {
  console.error("❌ Deployment failed:", err);
  process.exitCode = 1;
});

