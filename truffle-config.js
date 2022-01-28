const HDWalletProvider = require('@truffle/hdwallet-provider');

require('dotenv').config();
const mnemonic = process.env["MNEMONIC"];
const chainId = process.env["CHAIN_ID"];
const prodChainId = process.env["PROD_CHAIN_ID"];
const apiKey = process.env["APIKEY"];

module.exports = {

    /**
     * contracts_build_directory tells Truffle where to store compiled contracts
     */
    contracts_build_directory: './build',

    /**
     * contracts_directory tells Truffle where the contracts you want to compile are located
     */
    contracts_directory: './contracts',

    networks: {

        //polygon mainnet
        mainnet: {
            provider: () => new HDWalletProvider({
                mnemonic: {
                    phrase: mnemonic
                },
                providerOrUrl: "wss://polygon-mainnet.g.alchemy.com/v2/" + prodChainId
            }),
            network_id: 137,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true,
            chainId: 137
        },

        //polygon testnet
        mumbai: {
            provider: () => new HDWalletProvider({
                mnemonic: {
                    phrase: mnemonic
                },
                providerOrUrl: "wss://polygon-mumbai.g.alchemy.com/v2/" + chainId
            }),
            network_id: 80001,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true,
            chainId: 80001
        }
    },

    plugins: ['truffle-plugin-verify'],
    api_keys: {
        polygonscan: apiKey
    },

    // Set default mocha options here, use special reporters etc.
    mocha: {
        // timeout: 100000
    },

    // Configure your compilers
    compilers: {
        solc: {
            version: '0.8.11'
        }
    },
    db: {
        enabled: true
    }
}
