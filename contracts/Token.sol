// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

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

contract Token is IERC20 {

    using SafeMath for uint256;

    address private contractOwner;
    string public constant name = "Test Token";
    string public constant symbol = "TEST";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    
    uint256 totalSupply_ = 21 * 1000000 ether;

    constructor() {
        contractOwner = msg.sender;
        balances[contractOwner] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
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

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens // num of tokens to transfer
    ) public override returns (bool) {
        require(numTokens <= balances[owner]); // num of tokens to transfer must be LESS than or equal to the owner's balance
        require(numTokens <= allowed[owner][msg.sender]); // num of tokens to transfer must be LESS than or equal to amount delegated to the msg.sender address (the caller of the contract)

        balances[owner] = SafeMath.sub(balances[owner], numTokens);
        allowed[owner][msg.sender] = SafeMath.sub(allowed[owner][msg.sender], numTokens); // subtract from total delegated amount allowed 
        balances[buyer] = SafeMath.add(balances[buyer], numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
