// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {IERC165} from "./IERC165.sol";

interface IERC721 is IERC165 {

    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);
    
    function transferFrom(address from, address to, uint256 tokenId) external;
    /**
     * @dev Transfers the ownership of a given token ID to another address.
     * 
     * 1.safeTransferFrom会检查合约接收者是否实现了ERC721Receiver接口，如果实现了，则会调用ERC721Receiver接口的onERC721Received
     * 2.以确保代币转移的目标地址能够正确处理接收代币的逻辑.
     * 3.ERC-721 代币通常表示非同质化的数字资产，确保代币的安全传递非常关键。在 ERC-20 中，由于代币是可互换的，这种安全性检查并不是必需的。
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    
    function approve(address to, uint256 tokenId) external;
    
    function setApprovalForAll(address operator, bool approved) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * 检查批量授权
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}