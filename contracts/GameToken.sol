// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath { // Only relevant functions
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256)   {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract GameToken is IERC20 {

    using SafeMath for uint256;

    address private gameContract;
    address private contractOwner;
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    
    uint256 totalSupply_ = 100 * 1000000 ether; // 100 million tokens

    constructor(address owner, string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
        contractOwner = owner; // we pass in the creator account here as the contractOwner
        gameContract = msg.sender; // actial call from Game.sol sets sender as the game contract address
        balances[contractOwner] = totalSupply_;
    }

    modifier onlyGameContract()
    {
        require(msg.sender == gameContract, "msg.sender must be from the game contract address");
        _;
    }

    function totalSupply()
        external
        view
        override
        returns (uint256)
    {
        return totalSupply_;
    }

    function balanceOf(address owner)
        external
        view
        override
        returns (uint256)
    {
        return balances[owner];
    }

    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], numTokens);
        balances[receiver] = SafeMath.add(balances[receiver], numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function transferFromContractOwner(address receiver, uint256 numTokens)
        public
        returns (bool)
    {
        require(numTokens <= balances[contractOwner]);
        balances[contractOwner] = SafeMath.sub(balances[contractOwner], numTokens);
        balances[receiver] = SafeMath.add(balances[receiver], numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function directTransferFromUser(
        address userAcct,
        uint256 numTokens
    )
        public
        returns (bool)
    {
        require(numTokens <= balances[userAcct], "amount to transfer must be less than user's balance");
        balances[userAcct] = SafeMath.sub(balances[userAcct], numTokens);
        balances[contractOwner] = SafeMath.add(balances[contractOwner], numTokens);
        emit Transfer(userAcct, contractOwner, numTokens);
        return true;
    }
    
    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    )
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[owner], "amount to transfer must be less than user's balance"); // num of tokens to transfer must be LESS than or equal to the owner's balance
        require(numTokens <= allowed[owner][msg.sender], "amount must be less than delegated amount approved for spending"); // num of tokens to transfer must be LESS than or equal to amount delegated to the msg.sender address (the caller of the contract)

        balances[owner] = SafeMath.sub(balances[owner], numTokens);
        allowed[owner][msg.sender] = SafeMath.sub(allowed[owner][msg.sender], numTokens); // subtract from total delegated amount allowed 
        balances[buyer] = SafeMath.add(balances[buyer], numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
