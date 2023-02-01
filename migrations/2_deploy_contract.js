var PokemonTDToken = artifacts.require("./PokemonTDToken.sol");

module.exports = function(deployer) {
    let n = 1;
    deployer.deploy(PokemonTDToken, {from: arguments[2][n]});
};