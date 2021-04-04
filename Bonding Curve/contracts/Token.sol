// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public deployer;
    mapping(address => bool) public minters;

    constructor() {
        deployer = msg.sender;
    }

    function addMinter(address _minter) public onlyDeployer {
        minters[_minter] = true;
    }

    function mint(uint256 _amount, address _to) public onlyMinter {
        _mint(_to, _amount);
    }

    function burn(uint256 _amount, address _from) public onlyMinter {
        _burn(_from, _amount);
    }

    modifier onlyDeployer() {
        require(msg.sender == deployer, "U r not deployr");
        _;
    }

    modifier onlyMinter() {
        require(minters[msg.sender] == true, "U r not mintr");
        _;
    }
}
