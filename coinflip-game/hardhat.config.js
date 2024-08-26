require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

module.exports = {
  solidity: '0.8.20',
  networks: {
    rinkeby: {
      url: process.env.INFURA_API_KEY,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
};
console.log(`Private Key Length: ${process.env.PRIVATE_KEY.length}`);
console.log(`Private Key: ${process.env.PRIVATE_KEY}`);