// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IDexRouter.sol";

contract TokenSwapHelper {
    IDexRouter public constant swapRouter = IDexRouter(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); // sushi router address on polygon

    address private constant WETH = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619; // WETH token address on polygon

    address public immutable swapPair;

    IERC20 private immutable swapTokenAddress;

    address public immutable recipient;

    // Uniswap V3 SwapRouter address (depends on the network)
    constructor(address _tokenAddress, address _swapPair, address _recipient) {
        swapTokenAddress = IERC20(_tokenAddress);
        swapPair = _swapPair;
        recipient = _recipient;
    }

    function swapTokenForETH(uint256 amountIn, uint256 amountOutMin) external {
        require(msg.sender == address(swapTokenAddress), "TokenSwapHelper: Only the token can call this function");
        address[] memory path = new address[](2);
        path[0] = address(swapTokenAddress);
        path[1] = WETH;

        swapTokenAddress.approve(address(swapRouter), amountIn);

        // make the swap
        swapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            amountIn,
            0, // accept any amount of ETH
            path,
            recipient,
            block.timestamp + 300
        );
    }
}
