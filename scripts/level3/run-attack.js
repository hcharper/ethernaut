async function main() {
  const attackAddress = "0x2Fc1A0cd73b6FE79301Ab939466D85B327AF0cb9";
  const instanceAddress = "0x3b6330A4Dd02FaA22B3A069AD386f2AB71E14FE4";

  const CoinFlipAttack = await ethers.getContractFactory("CoinFlipAttack");
  const attack = CoinFlipAttack.attach(attackAddress);
  
  const CoinFlip = await ethers.getContractFactory("CoinFlip");
  const coinFlip = CoinFlip.attach(instanceAddress);

  for (let i = 1; i <= 10; i++) {
    console.log(`\n--- Attempt ${i}/10 ---`);
    
    try {
      const tx = await attack.flip();
      console.log("TX hash:", tx.hash);
      await tx.wait();
      
      const wins = await coinFlip.consecutiveWins();
      console.log("Consecutive wins:", wins.toString());
      
      if (wins >= 10n) {
        console.log("\n🎉 Level complete! You have 10 consecutive wins!");
        break;
      }
      
      if (i < 10) {
        console.log("Waiting 15 seconds for next block...");
        await new Promise(resolve => setTimeout(resolve, 15000));
      }
    } catch (error) {
      console.log("Error:", error.message);
      console.log("Waiting 15 seconds and retrying...");
      await new Promise(resolve => setTimeout(resolve, 15000));
      i--; // Retry this attempt
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
