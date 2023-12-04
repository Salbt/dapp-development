// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import {IERC20Metadata} from "./extensions/IERC20Metadata.sol";
import {IERC20} from "./IERC20.sol";
contract ERC20 is IERC20,IERC20Metadata{
    
    /**
     * @dev 账户的余额映射
     */
    mapping(address => uint256) private _balances;

    /**
     * @dev 地址批准使用代币限度的地址-余额的映射
     */
    mapping(address => mapping(address spender => uint256)) private _allowances;


    uint256 private _totalSupply;
    
    string private _name;
    string private _symbol;
    string private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * 这两个值应该是不变的，在构造器初始化一次后就不能更改了
     */
    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override  returns(string memory){
        return _name;
    }

    function symbol() public view virtual override returns(string memory){
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * token一般使用18作为精度，这个值是eth到wei转化的单位。重写可以更改token的精度
     */
    function decimal() public view virtual override  returns (uint8) {
        return 18;
    }

    // 以下函数是erc-20必须实现的函数

    function totalSupply() public view virtual override returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to,uint256 value) public virtual override returns(bool) {
        address owner = msg.sender;
        _transfer(owner,to,value);
        return true;
    }


    function transferFrom(address from, address to, uint256 value) public virtual override returns(bool){
        address owner = msg.sender;
        require(_allowances[from][owner] >= value, "ERC20: transfer amount exceeds allowance");
        _approve(from, to, _allowances[from][owner] - value);
        _transfer(owner, to, value);
        return true;
    }

    /**
     * 返回授权的地址可使用的代币余额
     */
    function allowance(address owner, address spender) public view virtual override returns(uint256) {
        return _allowances[owner][spender];
    }

    /**
     * 调用者将自己的代币授权给批准者使用
     * 注意批准的地址不能是零地址
     */
    function approve(address spender, uint256 value) public virtual override returns(bool){
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev 相当于erc20中实际的transfer，只能内部触发，完成转账工作
     * 转账不能使用零地址进行，from和to都不能是零地址
     *
     * 触发{Transfer}事件
     */
    function _transfer(address from, address to, uint256 value) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= value, "ERC20: transfer amount exceeds balance");
        
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);  

    } 

     /**
     * @dev 相当于erc20中实际的transfer，只能内部触发，完成转账工作
     * 批准不需要检查余额，在转账时会自动检查余额的多少
     *
     * 触发{Approval}事件
     */
    function _approve(address from, address to, uint256 value) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _allowances[from][to] = value;
        emit Approval(from, to, value);
    } 

    /**
     * @dev 铸造代币
     * 获得的铸造代币的地址不能是零地址
     * 货币总量会增加，铸造代币的地址的余额也会增加
     *
     * 触发{Transfer}事件
     */
    function _mint(address account, uint256 value) internal virtual  {
        require(account != address(0), "ERC20: mint to the zero address");
        
        _totalSupply += value;
        _balances[account] += value;
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev 销毁代币，相当于erc20中的burn
     * 销毁代币的地址不能是零地址，销毁代币的余额不能大于当前余额
     * 货币总量会减少，销毁代币的地址的余额会减少
     * 
     * 触发{Transfer}事件
     */
    function _burn(address account, uint256 value) internal virtual  {
        require(account != address(0), "ERC20: burn from the zero address");
        require(_balances[account] >= value, "ERC20: burn amount exceeds balance");
        
        _balances[account] -= value;
        _totalSupply -= value;
        emit Transfer(account, address(0), value);
    }


    
}


