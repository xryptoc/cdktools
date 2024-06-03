const path = require("path");
const fs = require("fs");

const createRollupOutputPath = path.join(__dirname, "../data/src/zkevm-contracts/deployment/v2/create_rollup_output.json");
const genesisPath = path.join(__dirname, "../data/src/zkevm-contracts/deployment/v2/genesis.json");
const deployOutputPath = path.join(__dirname, "../data/src/zkevm-contracts/deployment/v2/deploy_output.json");

const configOutputPath = path.join(__dirname, "../data/src/cdk-validium-node/test/config/test.genesis.config.json");

const create_rollup_parameters = require('../data/src/zkevm-contracts/deployment/v2/create_rollup_parameters.json');

const createRollupOutputJson = require(createRollupOutputPath);
const genesisJson = require(genesisPath);
const deployOutputJson = require(deployOutputPath);

async function main() {
    // test.genesis.config.json
    const outputJson = {
        l1Config: {
            chainId: create_rollup_parameters.chainID,
            polygonZkEVMAddress: createRollupOutputJson.rollupAddress,
            polygonRollupManagerAddress: deployOutputJson.polygonRollupManagerAddress,
            polTokenAddress: deployOutputJson.polTokenAddress,
            polygonZkEVMGlobalExitRootAddress: deployOutputJson.polygonZkEVMGlobalExitRootAddress,
        },
        rollupCreationBlockNumber: createRollupOutputJson.createRollupBlockNumber,
        rollupManagerCreationBlockNumber: deployOutputJson.deploymentRollupManagerBlockNumber,
        root: genesisJson.root,
        genesis: genesisJson.genesis,
    };

    fs.writeFileSync(configOutputPath, JSON.stringify(outputJson, null, 1));
    // test.genesis.config.json end
}

main().catch((e) => {
    console.error(e);
    process.exit(1);
});