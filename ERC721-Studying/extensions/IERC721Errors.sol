// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

/**
 * @dev Standard ERC-721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-721 tokens.
 */
interface IERC721Errors {
    /**
     * @dev 声明一个错误，一些地址不能是owner，比如: address(0)不能是owner
     * 一般在账户余额查询中使用: balanceOf()
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev 声明一个错误，检查tokenId的拥有者是否为address(0)
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev 声明一个与特定tokenId的所有权相关的错误
     * 一般在转账中使用：  transfers()
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev 声明一个与tokenId的发送者相关的错误，发送者不能是address(0)
     * 一般在转账中使用：  transfers()
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev 声明一个与tokenId的接收者相关的错误，接收者不能是address(0)
     * 或检查 IERC721Receiver.onERC721Received() 是否被实现, 以上两种情况都会报该错误
     * 一般在转账中使用： transfers()
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev 声明一个错误，检查某个对tokenId的操作者是否被approve
     * 一般在transfer中使: transfers()
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev 声明一个错误，检查某个操作的执行者是否是一个有效的批准者
     * 一般在approve中使用: approve()
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev 声明一个错误，检查某个操作的执行者是否是一个有效的owner
     * 一般在approvals中使用: approvals()
     */
    error ERC721InvalidOperator(address operator);
}