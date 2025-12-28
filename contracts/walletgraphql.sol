// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Key Notes:
- receive(): called when msg.data is empty and ETH is sent
- fallback(): called when msg.data is NOT empty (non-payable here → revert if ETH sent)
- ETH is never wasted, only gas is consumed on revert
*/

contract SimpleWallet {
    struct Transaction {
        address from;
        address to;
        uint256 timestamp;
        uint256 amount;
    }

    Transaction[] public transactionHistory;

    address public owner;
    bool public stop;

    /* =====================================================
                        EVENTS
    ===================================================== */

    event OwnerChanged(
        address indexed oldOwner,
        address indexed newOwner
    ); // ✅ ADDED

    event EmergencyToggled(bool stop); // ✅ ADDED

    event ContractFunded(
        address indexed sender,
        uint256 amount,
        uint256 timestamp
    ); // ✅ ADDED

    event ContractToUserTransfer(
        address indexed to,
        uint256 amount,
        uint256 timestamp
    ); // ✅ ADDED

    event OwnerWithdraw(
        address indexed owner,
        uint256 amount,
        uint256 timestamp
    ); // ✅ ADDED

    event DirectUserTransfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 timestamp
    ); // ✅ ADDED

    event UserToOwnerTransfer(
        address indexed from,
        address indexed owner,
        uint256 amount,
        uint256 timestamp
    ); // ✅ ADDED

    event SuspiciousActivityDetected(
        address indexed user,
        uint256 count
    ); // ✅ ADDED

    event EmergencyWithdrawal(
        address indexed owner,
        uint256 amount
    ); // ✅ ADDED

    /* =====================================================
                        MODIFIERS
    ===================================================== */

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You don't have access");
        _;
    }

    modifier isEmergencyDeclared() {
        require(stop == false, "Emergency declared");
        _;
    }

    mapping(address => uint256) suspiciousUser;

    modifier getSuspiciousUser(address _sender) {
        require(
            suspiciousUser[_sender] < 5,
            "Activity found suspicious, Try later"
        );
        _;
    }

    /* =====================================================
                    OWNER FUNCTIONS
    ===================================================== */

    function toggleStop() external onlyOwner {
        stop = !stop;
        emit EmergencyToggled(stop); // ✅ ADDED
    }

    function changOwner(address newOwner)
        public
        onlyOwner
        isEmergencyDeclared
    {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnerChanged(oldOwner, newOwner); // ✅ ADDED
    }

    /* =====================================================
                CONTRACT RELATED FUNCTIONS
    ===================================================== */

    function transferToContract(uint256 _startTime)
        external
        payable
        getSuspiciousUser(msg.sender)
    {
        require(block.timestamp > _startTime, "send after start time");

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );

        emit ContractFunded(
            msg.sender,
            msg.value,
            block.timestamp
        ); // ✅ ADDED
    }

    function transferToUserViaContract(
        address payable _to,
        uint256 _weiAmount
    ) external onlyOwner {
        require(address(this).balance >= _weiAmount, "Insufficient Balance");
        require(_to != address(0), "Adress format incorrect");

        _to.transfer(_weiAmount);

        transactionHistory.push(
            Transaction({
                from: address(this),
                to: _to,
                timestamp: block.timestamp,
                amount: _weiAmount
            })
        );

        emit ContractToUserTransfer(
            _to,
            _weiAmount,
            block.timestamp
        ); // ✅ ADDED
    }

    function withdrawFromContract(uint256 _weiAmount) external onlyOwner {
        require(address(this).balance >= _weiAmount, "Insuffficient balance");

        payable(owner).transfer(_weiAmount);

        transactionHistory.push(
            Transaction({
                from: address(this),
                to: owner,
                timestamp: block.timestamp,
                amount: _weiAmount
            })
        );

        emit OwnerWithdraw(
            owner,
            _weiAmount,
            block.timestamp
        ); // ✅ ADDED
    }

    function getContractBalanceInWei() external view returns (uint256) {
        return address(this).balance;
    }

    /* =====================================================
                    USER RELATED FUNCTIONS
    ===================================================== */

    function transferToUserViaMsgValue(address _to) external payable {
        require(_to != address(0), "Adress format incorrect");

        payable(_to).transfer(msg.value);

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: _to,
                timestamp: block.timestamp,
                amount: msg.value
            })
        );

        emit DirectUserTransfer(
            msg.sender,
            _to,
            msg.value,
            block.timestamp
        ); // ✅ ADDED
    }

    function receiveFromUser() external payable {
        require(msg.value > 0, "Wei Value must be greater than zero");

        payable(owner).transfer(msg.value);

        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: owner,
                timestamp: block.timestamp,
                amount: msg.value
            })
        );

        emit UserToOwnerTransfer(
            msg.sender,
            owner,
            msg.value,
            block.timestamp
        ); // ✅ ADDED
    }

    function getOwnerBalanceInWei() external view returns (uint256) {
        return owner.balance;
    }

    /* =====================================================
                RECEIVE & FALLBACK
    ===================================================== */

    receive() external payable {
        transactionHistory.push(
            Transaction({
                from: msg.sender,
                to: address(this),
                timestamp: block.timestamp,
                amount: msg.value
            })
        );

        emit ContractFunded(
            msg.sender,
            msg.value,
            block.timestamp
        ); // ✅ ADDED
    }

    function suspiciousActivity(address _sender) public {
        suspiciousUser[_sender] += 1;

        emit SuspiciousActivityDetected(
            _sender,
            suspiciousUser[_sender]
        ); // ✅ ADDED
    }

    fallback() external {
        suspiciousActivity(msg.sender);
    }

    /* =====================================================
                    EMERGENCY
    ===================================================== */

    function emergencyWithdrawl() external {
        require(stop == true, "Emergency not declared");

        uint256 balance = address(this).balance;
        payable(owner).transfer(balance);

        emit EmergencyWithdrawal(
            owner,
            balance
        ); // ✅ ADDED
    }

    /* =====================================================
                    VIEW FUNCTIONS
    ===================================================== */

    function getTransactionHistory()
        external
        view
        returns (Transaction[] memory)
    {
        return transactionHistory;
    }
}
