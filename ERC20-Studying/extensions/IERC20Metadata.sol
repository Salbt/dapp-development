// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {IERC20} from "../IERC20.sol";

/**
 *  @dev the Optional metadata function from the erc-20 standard 
 */
interface IERC20Metadata is IERC20{

    /**
     * @dev Returns the name of the token.
     * 代币名字
     */
    function name() external view returns(string memory);

     /**
     * @dev Returns the symbol of the token.
     * 代币的符号
     */
    function symbol() external view returns(string memory);

     /**
     * @dev Returns the decimals places of the token.
     * 小数点后的位数
     */ 
    function decimal() external view returns(uint8);

}