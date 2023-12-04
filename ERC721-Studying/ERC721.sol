// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {IERC721} from "./IERC721.sol";
import {IERC721Metadata} from "./extensions/IERC721Metadata.sol";
import {IERC165} from "./IERC165.sol";
import {IERC721Errors} from "./extensions/IERC721Errors.sol";
import {IERC721Receiver} from "./IERC721Receiver.sol";
import {Strings} from "./utils/Strings.sol";

contract ERC721 is 
    IERC721,
    IERC721Metadata,
    IERC721Errors{
    
    using Strings for uint256;

    string private _name;
    string private _symbol;
    /**
     * @dev 维护 tokenId 和其 owner 的映射
     */
    mapping(uint256 tokenId => address) private _owners;
    /**
     * @dev 维护 owner 和 tokenId拥有数量 的映射
     */
    mapping(address owner => uint256) private _balances;
    /**
     * @dev 维护 token 和其被授权的 approver 的映射
     */
    mapping(uint256 tokenId => address) private _tokenApprovals;
    /**
     * @dev 维护 owner 和 到operator地址 的批量授权映射
     */
    mapping(address owner => mapping(address operator => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

   
    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev 检查是否支持ERC721接口和ERC165接口
     */
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @dev 获取owner持有erc721 token持有的数量 
     */
    function balanceOf(address owner)public view override returns(uint256) {
        if (owner == address(0)){
            revert ERC721InvalidOwner(address(0));
        }
        return _balances[owner];
    }

    /**
     * @dev 获取tokenId持有者的地址,如果地址为address(0),方法会抛出错误
     */
    function ownerOf(uint256 tokenId) public view override returns (address) {
        address owner = _owners[tokenId];
        if (owner == address(0)) {
            revert ERC721NonexistentToken(tokenId);
        }
        return owner;
    }

       /**
     * @dev 批准 to 地址可以转移 owner 持有的token
     * 
     * 错误：owner不能为零地址
     *       msg.sender 不是token拥有者，也不是token的受托人
     */
    function approve(address to, uint256 tokenId) public override {
        address owner = _owners[tokenId];
        if (owner == address(0)) {
            revert ERC721NonexistentToken(tokenId);
        }

        if (owner != msg.sender && !isApprovedForAll(owner, msg.sender)){
            revert ERC721InvalidApprover(msg.sender);
        }

        _approve(owner,to, tokenId);
    }

     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev 将自己持有的一系列 token 批量授权给某个地址 operator
     */
    function setApprovalForAll(address operator, bool approved) public override {
        if (operator == address(0)){
            revert ERC721InvalidOperator(operator);
        }
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved); 
    }


    function _approve(address owner, address to, uint256 tokenId) internal  {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev tokenId 对应的 token 所有者转移给 to
     *
     * 需要检查 to 地址是否有效
     * 获得拥有者地址 owner
     * 检查 owner 地址是否有效
     * 检查 owner 是否是 from 
     * 转移 token 使用_transfer()方法
     */
    function transferFrom(address from, address to, uint256 tokenId) public override {
        if (to == address(0)) {
            revert ERC721InvalidReceiver(to);
        }
        address owner = _owners[tokenId];
        _transfer(owner,to, tokenId);
        if (owner != from) {
            revert ERC721IncorrectOwner(from, tokenId, owner);
        }
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        safeTransferFrom(from, to, tokenId, "");
    }
    
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, data);
    }

    function _mint(address to, uint256 tokenId) internal  {
        if (to == address(0)) {
            revert ERC721InvalidReceiver(address(0));
        }
        if (_owners[tokenId] != address(0)) {
            revert ERC721InvalidSender(address(0));
        }
        _owners[tokenId] = to;
        _balances[to] += 1;
        emit Transfer(msg.sender, to, tokenId);
    }
    

    

    function _burn(uint256 tokenId) internal  {
        address owner = ownerOf(tokenId);
        if(owner != msg.sender) {
            revert ERC721InvalidSender(msg.sender);
        }

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        _owners[tokenId] = address(0);
        emit Transfer(owner, address(0), tokenId);
        
    }
    /**
     * @dev 转移 token 所有权逻辑
     * 
     * 检查方法调用者是否有权限
     * 修改 _balances 和 _owner 完成转移逻辑
     * 清除授权  _tokenApprovals (不用清除 _operatorApprovals , 它是 owner到 aprover 的映射)      
     */
    function _transfer(address from, address to, uint256 tokenId) internal  {
        // 没有权限会报相关错误
        _checkAuthorized(from, msg.sender, tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        // 清除 approve
        _approve(from,address(0),tokenId);  
        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev 检查 spender 是否有tokenId的权限
     * 
     * 如果spender有权限就要满足以下条件：
     * 1. spender 必须不为 address(0) 
     * 2. spender 是 owner 或 spender 有授权（批量授权）
     */
    function _isAuthorized(address owner, address spender, uint256 tokenId) internal view returns (bool) {
        return
            spender != address(0) &&
            (owner == spender || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    /**
     * @dev 检查 tokenId 是否为授权
     * 
     * 如果没有授权会报错误
     * 错误： 1.检查 tokenId 是否为 address(0)
     *       2.操作者没有授权
     */
    function _checkAuthorized(address owner, address spender, uint256 tokenId) internal view {
        if (!_isAuthorized(owner, spender, tokenId)) {
            if (owner == address(0)) {
                revert ERC721NonexistentToken(tokenId);
            } else {
                revert ERC721InsufficientApproval(spender, tokenId);
            }
        }
    }
    /**
     * 检查地址，如果地址是账户，则返回true，是合约的话则会判断，该合约是否有引用IERC721Receiver这个接口
     * 作为EIP-721的要求，如果一个合约要接受EIP-721，其必须要实现onERC721Received方法，
       当用户调用safeTransferFrom时，会在转账结束时，调用to地址的onERC721Received方法，
     * 此时该方法的返回值应该为bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private {
        if (to.code.length > 0) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                if (retval != IERC721Receiver.onERC721Received.selector) {
                    revert ERC721InvalidReceiver(to);
                }
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert ERC721InvalidReceiver(to);
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
    }

      function tokenURI(uint256 tokenId)public view override returns (string memory)
    {
        ownerOf(tokenId);

        string memory baseURI = _baseURI();
        // return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
        return
            bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI)) : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
}
