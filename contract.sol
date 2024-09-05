// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event burningToken(address _founder, uint _quantity);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract GDCOIN is IERC20{
    string public name="GDCOIN";
    string public symbol="GDC";
    uint public decimal=0;
    address public founder;
    uint public totalSupply;
    mapping(address=>mapping(address=>uint)) allowed;
    mapping(address=>uint) public balances;
    mapping(address => bool) public isFreeze;
    bool stopAllFunctions;

    constructor(){
        founder=msg.sender;
        totalSupply=1000;
        balances[founder]=totalSupply;
    }

    modifier freezeStatus(){
        require(isFreeze[msg.sender]==false,"Your account is freezed");
        _;
    }
    modifier emergencyStatus(){
        require(stopAllFunctions==false,"Emergency declared");
        _;
    }
    modifier isFounder() {
        require(msg.sender==founder, "You are not the founder");
        _;
    }

    function balanceOf(address account) external view returns (uint256){
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) external freezeStatus() emergencyStatus()
        returns (bool){
        require(amount>0,"Amount must be greater than zero");
        require(balances[msg.sender]>=amount,"You don't have enough balance");
        balances[msg.sender]-=amount;
        balances[recipient]+=amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256){
        return allowed[owner][spender];
    }

    function approve(address spender, uint256 amount) external freezeStatus() emergencyStatus()
        returns (bool){
        require(amount>0,"Amount must be greater than zero");require(balances[msg.sender]>=amount,"You don't have enough balance");
        allowed[msg.sender][spender]=amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

}