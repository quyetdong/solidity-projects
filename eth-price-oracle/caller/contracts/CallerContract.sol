pragma solidity 0.8.10;

//1. Import from the "./EthPriceOracleInterface.sol" file
import "./EthPriceOracleInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CallerContract is Ownable {
    uint256 private ethPrice;
    EthPriceOracleInterface private oracleInstance;
    address private oracleAddress;
    event newOracleAddressEvent(address oracleAddress);

    mapping(uint256 => bool) public myRequests;
    event ReceiveNewRequestIdEvent(uint256 id);
    event PriceUpdatedEvent(uint256 ethPrice, uint256 id);

    function setOracleInstanceAddress(address _oracleInstanceAddress)
        public
        onlyOwner
    {
        oracleAddress = _oracleInstanceAddress;
        //3. Instantiate `EthPriceOracleInterface`
        oracleInstance = EthPriceOracleInterface(oracleAddress);
        emit newOracleAddressEvent(oracleAddress);
    }

    // Define the `updateEthPrice` function
    function updateEthPrice() public {
        uint256 id = oracleInstance.getLatestEthPrice();
        myRequests[id] = true;
        emit ReceiveNewRequestIdEvent(id);
    }

    function callback(uint256 _ethPrice, uint256 _id) public onlyOracle {
        // 3. Continue here
        require(
            myRequests[_id] == true,
            "This request is not in my pending list."
        );
        ethPrice = _ethPrice;
        delete myRequests[_id];

        emit PriceUpdatedEvent(_ethPrice, _id);
    }

    modifier onlyOracle() {
      // Start here
      require(msg.sender == oracleAddress, "You are not authorized to call this function.");
      _;
    }

}
