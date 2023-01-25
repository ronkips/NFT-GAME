const hardhat = require("hardhat");

const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
  const gameContract = await gameContractFactory.deploy(
    ["Nash", "Samu", "Ken"], // Names
    [
      "https://i.imgur.com/pKd5Sdk.png",
      "https://i.imgur.com/xVu4vFL.png", //Images
      "https://i.imgur.com/u7T87A6.png"
      // "https://pin.it/1oD4aWF"
    ],
    [500, 900, 1200], // kip values
    [50, 100, 200], //Attack damage values
    "Hillary", //Boss name
    "https://i.imgur.com/AksR0tt.png", //Boss image
    1000000, // Boss kip
    50 // Boss attack damage
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  // let txn;
  // txn = await gameContract.mintCharacterNFT(0);
  // await txn.wait();
  // console.log("Minted NFT #1");

  // txn = await gameContract.mintCharacterNFT(1);
  // await txn.wait();
  // console.log("Minted NFT #2");

  // txn = await gameContract.mintCharacterNFT(2);
  // await txn.wait();
  // console.log("Minted NFT #3");

  // txn = await gameContract.mintCharacterNFT(3);
  // await txn.wait();
  // txn = await gameContract.attackBoss();
  // await txn.wait();

  // txn = await gameContract.attackBoss();
  // await txn.wait();

  console.log("Done!");
  // console.log("****************************************************\n");
  // Get the value of the NFT's URI.
  // let returnedTokenUri = await gameContract.tokenURI(2);
  // console.log("Token URI", returnedTokenUri);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
