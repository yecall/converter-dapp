pragma solidity ^0.4.4;

contract Token {

    function totalSupply() public view returns (uint);

    function balanceOf(address tokenOwner) public view returns (uint balance);

    function allowance(address tokenOwner, address spender) view public returns (uint remaining);

    function transfer(address to, uint tokens) public returns (bool success);

    function approve(address spender, uint tokens) public returns (bool success);

    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract Converter is Ownable {

	struct ChainAddress {
        bool enabled;
        string chainAddress;
    }

    event CheckIn(address userAddress, uint256 amount, string chainAddress);

    event TokenWithdrawn(address userAddress, uint256 amount);

    event ConfOpenSet(bool confOpen);
	
	mapping(address => uint256) public amountMap;
	mapping(address => ChainAddress) public chainAddressMap;

	//config variable section
    bool public confOpen = true;

    address public tokenAddress;

	//modifier section
    modifier onlyOpen(){
        require(confOpen, "not open");
        _;
    }

    constructor(address newTokenAddress) public {
        owner = msg.sender;
        tokenAddress = newTokenAddress;
    }

    function checkIn(uint256 checkInAmount, string checkInChainAddress) onlyOpen public returns (string) {

    	Token token = Token(tokenAddress);
    	address userAddress = msg.sender;
    	uint256 allowance = token.allowance(userAddress, this);
    	require(checkInAmount <= allowance, "amount is bigger than allowance");

    	token.transferFrom(userAddress, this, checkInAmount);

    	amountMap[userAddress] += checkInAmount;
    	if (!chainAddressMap[userAddress].enabled) {
    		chainAddressMap[userAddress] = ChainAddress(true, checkInChainAddress);
    	}

    	emit CheckIn(userAddress, checkInAmount, checkInChainAddress);

    }

    function withdrawToken(uint256 value, address userAddress) onlyOwner public {
        Token token = Token(tokenAddress);
        token.transfer(userAddress, value);

        emit TokenWithdrawn(userAddress, value);
    }

    function setConfOpen(bool open) onlyOwner public {
        confOpen = open;

        emit ConfOpenSet(open);
    }

}


