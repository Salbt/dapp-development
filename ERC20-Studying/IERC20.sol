// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0; 

interface IERC20{

    /**
     * @dev Emitted when 'value' tokens are move from one account('from') to another('to')
     * 
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

     /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns then value of token in exixtence
     */
    function totalSupply() external view returns(uint256);

    /**
     * @dev  Returns the value of tokens owned by 'account'.
     */
    function balanceOf(address account) external view returns(uint256);

    /**
     * @dev  Returns the remaining number of tokens that 'spender' will be
     * allowed to spend on behalf of 'owner' through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns(uint256);

    /**
     * @dev Sets a 'value' amount of tokens as the allowance of 'spender' over the
     * caller's tokens.
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns(bool);

    /**
     * @dev Moves a 'value' amount of tokens from the caller's account to 'to'.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address from, uint256 to) external returns(bool);

    /**
     * @dev Moves a 'value' amount of tokens from 'from' to 'to' using the
     * allowance mechanism. 'value' is then deducted from the caller's
     * allowance.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns(bool);


}