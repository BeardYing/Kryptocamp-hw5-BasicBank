// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "../src/BasicBank.sol";

import {StakingToken, RewardToken} from "../src/Token.sol";

contract BasicBankTest is Test {
    StakingToken public st;
    RewardToken public rt;
    BasicBank public stBank;
    uint256 public dealingTimestamp;
    uint8 public logCounter;
    uint256 timeStaking = 100;

    function setUp() public {
        st = new StakingToken(); // 預設啟用 mint 會給 此份合約
        rt = new RewardToken();
        stBank = new BasicBank(IERC20(address(st)) , IERC20(address(rt)));

        st.transfer(address(0x1), 5000); // 合約轉帳 5,000 給測試帳號 address(0x1)
        rt.transfer(address(stBank), 100 * 1e18); // 將所有錢轉到 bank 合約中，方便發放token
        emit log(string.concat(unicode"[INIT] Owner 擁有的流動 StakingToken 數量 ", vm.toString(st.balanceOf(address(this)))));
        emit log(string.concat(unicode"[INIT] 0x1 擁有的流動 StakingToken 數量 ", vm.toString(st.balanceOf(address(0x1)))));
        emit log(string.concat(unicode"[INIT] 銀行 StakingToken 質押總數量 = ", vm.toString(stBank.totalStacking())));
        emit log("============");
        logCounter = 0;
    }

    function _showAllBalance( address _user) private {
        emit log(string.concat("[", vm.toString(logCounter) , unicode"] address(0x1) 流動 StakingToken = ", vm.toString(st.balanceOf(_user))));
        emit log(string.concat("[", vm.toString(logCounter) , unicode"] address(0x1) 質押 StakingToken = ", vm.toString(stBank.balanceOf(_user))));
        emit log(string.concat("[", vm.toString(logCounter) , unicode"] address(0x1) 獎勵 RewardToken = ", vm.toString(stBank.rewardOf(_user))));
        emit log(string.concat("[", vm.toString(logCounter) , unicode"] BANK 總質押數 = ", vm.toString(stBank.totalStacking())));
        emit log("============");
        logCounter += 1;
    }


    function testBankDeposit(uint256 _deposit) public {
        vm.assume(_deposit <= 5000);
        // 基本存款測試
        vm.startPrank(address(0x1)); // 轉換帳號
        IERC20(st).approve(address(stBank), _deposit); // address(0x1) approve 給 銀行轉賬權限 (轉多少給多少)
        dealingTimestamp = block.timestamp;
        stBank.deposit(_deposit); // 存款 5000
        _showAllBalance(address(0x1));
        assertEq( stBank.balanceOf(address(0x1)) , _deposit ); // 檢查是否正常質押
        // 基本存款完成
    }

    // 測試取款 - 未到時間
    function testBankWithdrawExcept() public {
        // 先進行基本的存款操作
            testBankDeposit(5000); // 固定給予5000
        // 繼續

        // 測試未到時間的取款
        vm.warp(uint256(dealingTimestamp));
        vm.expectRevert(abi.encodePacked("Withdrawal Period is not reached yet")); // 判斷應該要吐出的錯誤訊息，（因為鎖倉時間還沒到）
        stBank.withdraw(0);
        emit log(unicode"✅ 通過鎖倉前提款錯誤訊息判斷");
        _showAllBalance(address(0x1));
    }

    // 測試取款 - 已到時間，正常取款 , 順便檢查利息
    function testBankWithdraw() public {
        // 先進行基本的存款操作
            testBankDeposit(5000); // 固定給予5000
        // 繼續
        
        vm.warp(uint256(dealingTimestamp)+ uint256(timeStaking));
        stBank.withdraw(0);
        _showAllBalance(address(0x1));
        
    }

    function testBankReward() public {
        // 接續上方通過的取款後續工作
            testBankWithdraw(); 
        
        // 檢測利息是否正確
        assertEq( 5000 * timeStaking * stBank.rewardRate() , stBank.rewardOf(address(0x1))); // 測試是否正常轉入      
        emit log(unicode"✅ 通過獎勵金額計算");
        uint256 rewardBeforeTx = stBank.rewardOf(address(0x1));

        // 轉出 所有獎勵利息
        stBank.getReward();

        // 檢查相關數據是否正常歸0
        assertEq( 0 , stBank.rewardOf(address(0x1)));
        emit log(unicode"✅ 通過重置銀行獎勵!");
        assertEq( rt.balanceOf(address(0x1)) , rewardBeforeTx );
        emit log(unicode"✅ 通過獎勵金額判斷!");
    }
}