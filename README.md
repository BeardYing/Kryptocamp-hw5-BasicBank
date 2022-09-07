# Beard | C0041103 - 第 5 週作業

## 建立一個 Bank 銀行
在 web3 世界人人都可以當銀行家！我們想開張一間去中心化金融中心，簡易小而美的銀行

### Bank 基本題
> 使用者可以將我們發行的 Staking Token (ERC20代幣)存入銀行
> 使用者執行定存，會開始計算 Reward 利息回饋
> 使用者解除定存（withdraw），獲得 Reward 利息回饋
> 部署二個合約，
> 
> 部署一個 Staking Token ERC20 的智能合約
> 提示：可透過 Openzeppelin Wizard 快速產生 ERC20
> 
> 部署一個 Bank 銀行合約，並擁有以下功能
> Deposit 定存：實作 deposit function，可以將 Staking Token 存入 Bank 合約
> Withdraw 解除定存並提款，實作 withdraw function
> TimeLock 固定鎖倉期
> 部署方式：Remix JavaScript VM 部署合約



### Bank 進階題
> 進階題可不做，但需繳交基本作業
> 
> 部署兩個 ERC20 Token 的智能合約，分別是 StakingToken、RewardsToken
> 部署 AdvanceBank 智能合約，並擁有以下功能
> Deposit 定存
> Reward（回饋另一個 RewardsToken）
> TimeLock 根據鎖倉期給予不同回饋加乘
> 合約部署在 Goerli Network，並開源 Verify


作業說明：[Hackmd](https://hackmd.io/MIH-COpTSK6S1WjyaBnUww?both)
