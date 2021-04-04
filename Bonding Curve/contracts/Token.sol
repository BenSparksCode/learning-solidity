// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public deployer;
    mapping(address => bool) public minters;

    constructor() ERC20("Bonding Curve Token","BCT") {
        deployer = msg.sender;
        minters[msg.sender] = true;
    }

    function addMinter(address _minter) public onlyDeployer {
        minters[_minter] = true;
    }

    function mint(address _to, uint256 _amount) public onlyMinter {
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) public onlyMinter {
        _burn(_from, _amount);
    }

    modifier onlyDeployer() {
        require(msg.sender == deployer, "U r not deployr ser");
        _;
    }

    modifier onlyMinter() {
        require(minters[msg.sender], "U r not mintr ser");
        _;
    }
}
