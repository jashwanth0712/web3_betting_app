/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: '0.8.9',
    defaultNetworks:'goerli',
    networks : {
      hardhat :{},
      goerli :{
        url : `https://rpc.ankr.com/eth_goerli`,
        accounts:[`0X${process.env.PRIVATE_KEY}`]
      }
    },
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
