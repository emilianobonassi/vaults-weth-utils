// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

interface IWETH9 {
    function deposit() payable external ;
    function withdraw(uint wad) external;
    function approve(address guy, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) external;
    function balanceOf(address src) external view returns (uint balance);
}