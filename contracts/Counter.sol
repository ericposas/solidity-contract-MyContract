// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Counter {

    address owner;
    address factory;
    uint count;

    modifier factoryOnly() {
        require(msg.sender == owner);
        _;
    }

    constructor(address address_)
    {
        owner = address_;
        factory = msg.sender;
    }

    function getCount()
        public
        view
        returns(uint)
    {
        return count;
    }

    function incrementCount()
        public
    {
        count++;
    }

}

    // methods if Counter.sol is imported and instantiated as
    // new Contract(address) into a mapping (address => Counter)
    
    // function createCounter()
    //     public
    // {
    //     counters[msg.sender] = new Counter(msg.sender);
    // }

    // modifier counterMustExist() {
    //     require(counters[msg.sender] != Counter(0x0000000000000000000000000000000000000000));
    //     _;
    // }

    // function getCounter()
    //     public
    //     view
    //     counterMustExist
    //     returns(Counter)
    // {
    //     return counters[msg.sender];
    // }

    // function incrementCounter()
    //     public
    //     counterMustExist
    // {
    //     counters[msg.sender].incrementCount();
    // }

    // function getCountFromCounter()
    //     public
    //     view
    //     counterMustExist
    //     returns(uint)
    // {
    //     return counters[msg.sender].getCount();
    // }