const hre = require('hardhat')

async function main() {
  const [deployer] = await hre.ethers.getSigners()
  console.log(
    'Deploying Lottery contracts with the account :',
    deployer.address,
  )

  const LotteryContract = await hre.ethers.getContractFactory('Lottery')
  const lottery = await LotteryContract.deploy()

  await lottery.deployed()

  console.log('Lottery contract deployed to ', lottery.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    process.exit(1)
  })
