pragma solidity 0.8.10;

//1. Import from the "./EthPriceOracleInterface.sol" file
import "./EthPriceOracleInterface.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract CallerContract is Ownable {
  // 2. Declare `EthPriceOracleInterface`
  EthPriceOracleInterface private oracleInstance;
  address private oracleAddress;
  event newOracleAddressEvent(address oracleAddress);

  function setOracleInstanceAddress (address _oracleInstanceAddress) public onlyOwner {
    oracleAddress = _oracleInstanceAddress;
    //3. Instantiate `EthPriceOracleInterface`
    oracleInstance = EthPriceOracleInterface(oracleAddress);
    emit newOracleAddressEvent(oracleAddress);
  }
}
