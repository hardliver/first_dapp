// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

contract LifeMeaning {
    uint public lifeMeaning;

    function set(uint x) public {
        lifeMeaning = x;
    }

    function get() public view returns (uint) {
        return lifeMeaning;
    }
}
