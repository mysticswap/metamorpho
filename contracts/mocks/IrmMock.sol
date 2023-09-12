// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import {IIrm} from "@morpho-blue/interfaces/IIrm.sol";
import {MarketParams, Market} from "@morpho-blue/interfaces/IMorpho.sol";

import {MathLib} from "@morpho-blue/libraries/MathLib.sol";

contract IrmMock is IIrm {
    using MathLib for uint128;

    uint256 public rate;

    function setRate(uint256 newRate) external {
        rate = newRate;
    }

    function borrowRateView(MarketParams memory, Market memory market) public view returns (uint256) {
        uint256 utilization = market.totalBorrowAssets.wDivDown(market.totalSupplyAssets);

        // When rate is zero, x% utilization corresponds to x% APR.
        return rate == 0 ? utilization / 365 days : rate / 365 days;
    }

    function borrowRate(MarketParams memory marketParams, Market memory market) external view returns (uint256) {
        return borrowRateView(marketParams, market);
    }
}
