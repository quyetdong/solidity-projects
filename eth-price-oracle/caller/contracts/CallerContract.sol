pragma solidity 0.8.10;
//1. Import from the "./EthPriceOracleInterface.sol" file
import "./EthPriceOracleInterface.sol";

contract CallerContract {
  // 2. Declare `EthPriceOracleInterface`
  EthPriceOracleInterface private oracleInstance;
  address private oracleAddress;

  function setOracleInstanceAddress (address _oracleInstanceAddress) public {
    oracleAddress = _oracleInstanceAddress;
    //3. Instantiate `EthPriceOracleInterface`
    oracleInstance = EthPriceOracleInterface(oracleAddress);
  }
}
