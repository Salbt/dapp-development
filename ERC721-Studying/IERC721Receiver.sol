// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC-721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC-721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * 如果合约需要接收erc721代币，则需要实现此方法。这个方法是为了保证你的合约能够正确地处理代币转移
     * 该函数返回一个 bytes4 类型的值，用于验证是否正确实现了接口。
     * 具体的返回值是 bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}