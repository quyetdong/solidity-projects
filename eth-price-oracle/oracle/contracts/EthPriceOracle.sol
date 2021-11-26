pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./CallerContractInterface.sol";

contract EthPriceOracle is AccessControl {
    uint256 private randNonce = 0;
    uint256 private modulus = 1000;
    uint numOracles = 0;
    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    mapping(uint256 => bool) pendingRequests;
    event GetLatestEthPriceEvent(address callerAddress, uint256 id);
    event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
    event RemoveOracleEvent(address oracleAddress);
    event AddOracleEvent(address oracleAddress);

    constructor(address _owner) {
        _setRoleAdmin(ORACLE_ROLE, DEFAULT_ADMIN_ROLE);
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
    }

    function addOracle(address _oracle) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(!hasRole(ORACLE_ROLE, _oracle), "Already an oracle!");
        grantRole(ORACLE_ROLE, _oracle);
        numOracles++;
        emit AddOracleEvent(_oracle);
    }

    function removeOracle(address _oracle) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(hasRole(ORACLE_ROLE, _oracle), "Not an oracle!");
        // 3. Continue here
        require(numOracles > 1, "Do not remove the last oracle!");
        revokeRole(ORACLE_ROLE, _oracle);
        numOracles--;
        emit RemoveOracleEvent(_oracle);
    }

    function getLatestEthPrice() public returns (uint256) {
        randNonce++;
        uint256 id = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))
        ) % modulus;

        // Start here
        pendingRequests[id] = true;
        emit GetLatestEthPriceEvent(msg.sender, id);
        return id;
    }

    function setLatestEthPrice(
        uint256 _ethPrice,
        address _callerAddress,
        uint256 _id
    ) public {
        require(
            pendingRequests[_id],
            "This request is not in my pending list."
        );
        delete pendingRequests[_id];

        // Start here
        CallerContractInterface callerContractInstance;
        callerContractInstance = CallerContractInterface(_callerAddress);

        callerContractInstance.callback(_ethPrice, _id);
        emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
    }
}
