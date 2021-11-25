pragma solidity 0.8.10;

interface CallerContractInterface {
  function callback(uint256 _ethPrice, uint256 id) external;
}
