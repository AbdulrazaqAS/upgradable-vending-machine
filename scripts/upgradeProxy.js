const { ethers, upgrades } = require('hardhat');

const proxyAddress = '0x94Da02F370ED86F9aD1Ec9dCBf3203e6Dc659761';

async function main() {
  // const VendingMachineV4 = await ethers.getContractFactory('VendingMachineV4');
  // const upgraded = await upgrades.upgradeProxy(proxyAddress, VendingMachineV4);
  // await upgraded.waitForDeployment();

  const implementationAddress = await upgrades.erc1967.getImplementationAddress(
    proxyAddress
  );

  // console.log("The current contract owner is: " + await upgraded.owner());
  console.log('Implementation contract address: ' + implementationAddress);
}

main();