// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./Token.sol";
// import "./CollateralToken";
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

    function mint(uint256 _amount) public returns(bool){
        uint256 cost = buyPrice(_amount);

        require(
            collateralToken.allowance(msg.sender, address(this)) >= cost,
            "Not approved to spend CLT"
        );

        // Take buyer's collateral
        require(
            collateralToken.transferFrom(msg.sender, address(this), cost),
            "Collateral transfer failed."
        );

        // Send buyer newly minted tokens
        bondedToken.mint(msg.sender, _amount);
    }

    function burn(uint256 _amount) public returns(bool){
        uint256 payout = sellReward(_amount);

        // Take buyer's bonded token - and burn
        bondedToken.burn(msg.sender, _amount);
        // Send buyer collateral token from curve's balance
        collateralToken.transfer(msg.sender, payout);
    }

    function calcIntegral(uint256 a, uint256 b) internal returns (uint256) {
        require(a < b, "a must be < b");
        uint256 res = (b**2 - a**2) + 40 * (b - a);
        return res / 200; //ASK - why not do this calc in 1 line?
    }
}
