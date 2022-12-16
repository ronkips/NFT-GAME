const hardhat = require("hardhat");

const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
  const gameContract = await gameContractFactory.deploy(
    ["Hilla", "Samu", "Nash", "Ken"], // Names
    [
      "https://pin.it/2AGSyjR",
      "https://pin.it/4lg7rns", //Images
      "https://pin.it/1TDqyU2",
      "https://pin.it/1oD4aWF"
    ],
    [500, 700, 900, 1200], // kip values
    [50, 80, 100, 200], //Attack damage values
    "Hillary", //Boss name
    "https://pin.it/17opdkP", //Boss image
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
  console.log("****************************************************\n");
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
