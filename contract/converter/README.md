# Rinkeby deploy result
```
> transaction hash:    0x468326c0bf7081083552e66b5473e55705b37e1e661625724e8e6a191fc35ca9
> Blocks: 2            Seconds: 25
> contract address:    0x5EB5E7AE8300Cfc1f08ed6fa5eAe93B95160d996
> block number:        6658728
> block timestamp:     1592036394
> account:             0xb8958D5A4089793c751901034693eDc3708f0324
> balance:             18.637195
> gas used:            961465 (0xeabb9)
> gas price:           20 gwei
> value sent:          0 ETH
> total cost:          0.0192293 ETH
```

## ABI
```
[
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "name": "amountMap",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "tokenAddress",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "confOpen",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "name": "chainAddressMap",
    "outputs": [
      {
        "name": "enabled",
        "type": "bool"
      },
      {
        "name": "chainAddress",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "name": "newTokenAddress",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "userAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "chainAddress",
        "type": "string"
      }
    ],
    "name": "CheckIn",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "userAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "TokenWithdrawn",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "confOpen",
        "type": "bool"
      }
    ],
    "name": "ConfOpenSet",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "checkInAmount",
        "type": "uint256"
      },
      {
        "name": "checkInChainAddress",
        "type": "string"
      }
    ],
    "name": "checkIn",
    "outputs": [
      {
        "name": "",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "value",
        "type": "uint256"
      },
      {
        "name": "userAddress",
        "type": "address"
      }
    ],
    "name": "withdrawToken",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "open",
        "type": "bool"
      }
    ],
    "name": "setConfOpen",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  }
]
```

## Test account
```
champion gadget normal mixed critic inform shine fabric train flush trim credit
```