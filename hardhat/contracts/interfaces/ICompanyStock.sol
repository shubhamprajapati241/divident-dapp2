// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20Plugins} from "@1inch/token-plugins/contracts/interfaces/IERC20Plugins.sol";

interface ICompanyStock is IERC20Plugins {
    function mint(address account, uint256 amount) external;

    function burn(address account, uint256 amount) external;
}
