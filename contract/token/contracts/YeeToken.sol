pragma solidity ^0.4.4;
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract YeeCoin is StandardToken {
  string public name = "YeeCoin";
  string public symbol = "YEE";
  uint8 public decimals = 18;
  uint256 public INITIAL_SUPPLY = 10000000000000000000000000000;

  constructor() public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}

