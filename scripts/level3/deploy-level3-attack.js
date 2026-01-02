async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);
  console.log("Account balance:", (await ethers.provider.getBalance(deployer.address)).toString());

  // Ethernaut contract instance
  const instanceAddress = "0x3b6330A4Dd02FaA22B3A069AD386f2AB71E14FE4";

  const CoinFlipAttack = await ethers.getContractFactory("CoinFlipAttack");
  const attack = await CoinFlipAttack.deploy(instanceAddress);

  await attack.waitForDeployment();

  console.log("CoinFlipAttack deployed to:", await attack.getAddress());
  console.log("\nNext steps:");
  console.log("1. Wait ~15 seconds for a new block");
  console.log("2. Call attack() — repeat 10 times (once per block)");
  console.log("3. Check consecutiveWins on the instance reaches 10");
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });