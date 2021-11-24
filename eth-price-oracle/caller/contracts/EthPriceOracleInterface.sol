pragma solidity 0.8.10;

abstract contract EthPriceOracleInterface {
  function getLatestEthPrice() virtual public returns (uint256);
}
