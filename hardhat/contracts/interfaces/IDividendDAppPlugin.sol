// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPlugin} from "@1inch/token-plugins/contracts/interfaces/IPlugin.sol";

interface IDividendDAppPlugin is IPlugin, IERC20 {
    function setDividend(uint256 value) external payable;
    function claimDividend() external;
}
