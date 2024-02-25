// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Plugin} from "@1inch/token-plugins/contracts/Plugin.sol";
import {IERC20Plugins} from "@1inch/token-plugins/contracts/interfaces/IERC20Plugins.sol";
import {IDividendDAppPlugin} from "./interfaces/IDividendDAppPlugin.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract DividendDAppPlugin is IDividendDAppPlugin, Plugin, ERC20, Ownable {
    error ApproveDisabled();
    error TransferDisabled();

    mapping(address => uint256) public ledger;
    mapping(address => bool) public claimedDividend;
    uint256 public totalSubscribedSupply;
    uint256 public totalDividendPool;
    uint256 public totalClaimedDividend;
    address[] public claimedUsers;

    constructor(
        string memory name_,
        string memory symbol_,
        IERC20Plugins token_
    ) ERC20(name_, symbol_) Plugin(token_) Ownable(msg.sender) {}

    function setDividend(uint256 value) public payable onlyOwner(){
        totalDividendPool = value;
        totalClaimedDividend = 0;
        // reset claimed dividend
        for (uint256 i = 0; i < claimedUsers.length; i++) {
            claimedDividend[claimedUsers[i]] = false;
        }
        claimedUsers = new address[](0);
    }

    function claimDividend() public {
        require(
            !claimedDividend[msg.sender],
            "DividendDispatcherPlugin: already claimed dividend"
        );
        claimedUsers.push(msg.sender);
        claimedDividend[msg.sender] = true;
        uint256 _multi = ledger[msg.sender] * totalDividendPool;
        uint256 dividend = _multi / totalSubscribedSupply;

        totalClaimedDividend += dividend;

        address addr = msg.sender;
        address payable wallet = payable(addr);
        wallet.transfer(dividend);
    }

    function _updateBalances(
        address from,
        address to,
        uint256 amount
    ) internal override {
        // mint
        if (from == address(0)) {
            totalSubscribedSupply += amount;
            ledger[to] = ledger[to] + amount;

            // burn
        } else if (to == address(0)) {
            ledger[from] = ledger[from] - amount;
            totalSubscribedSupply -= amount;

            // transfer
        } else {
            ledger[from] = ledger[from] - amount;
            ledger[to] = ledger[to] + amount;
        }
    }

    // ERC20 overrides
    function transfer(
        address /* to */,
        uint256 /* amount */
    ) public pure override(IERC20, ERC20) returns (bool) {
        revert TransferDisabled();
    }

    function transferFrom(
        address /* from */,
        address /* to */,
        uint256 /* amount */
    ) public pure override(IERC20, ERC20) returns (bool) {
        revert TransferDisabled();
    }

    function approve(
        address /* spender */,
        uint256 /* amount */
    ) public pure override(ERC20, IERC20) returns (bool) {
        revert ApproveDisabled();
    }
}
