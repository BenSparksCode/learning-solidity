// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Token.sol";
import "./CollateralToken";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Curve {
    IERC20 public collateralToken;
    Token public bondedToken;

    constructor(address _collateralToken, address _bondedToken) {
        collateralToken = IERC20(_collateralToken);
        bondedToken = Token(_bondedToken);
    }

    function buyPrice(uint256 _amount) public view returns (uint256) {
        return calcIntegral(Token.totalSupply(), Token.totalSupply()+_amount);
    }

    function sellReward(uint256 _amount) public view returns (uint256) {
        return calcIntegral(Token.totalSupply()-_amount, Token.totalSupply());
    }

    function collateralToken() public view returns (address) {
        return address(collateralToken);
    }

    function bondedToken() public view returns (address) {
        return address(bondedToken);
    }

    function calcIntegral(uint256 a, uint256 b) internal returns (uint256) {
        require(a <= b, "a must be <= b");

        if (a == b) {
            return 0;
        } else {
            uint256 res = (b**2 - a**2) + 40 * (b - a);
            return res / 200; //ASK - why not do this in 1 line?
        }
    }
}
