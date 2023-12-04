// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev 该方法接受一个代表接口标识符的参数，返回一个布尔值，指示合约是否支持该接口
     * 我们可以使用该方法检查合约是否支持ERC721等接口
     * 
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}