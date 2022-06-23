# PuerHub 智能合约

English | [简体中文](README-zh.md)

[![Node.js CI](https://github.com/PuerHub/contract/actions/workflows/node.yml/badge.svg)](https://github.com/PuerHub/contract/actions/workflows/node.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Conflux Form](https://img.shields.io/badge/Conflux-Forum-brightgreen)](https://forum.conflux.fun/t/137-puerhub-l1/15270)

Conflux Core(主网):

[cfx:acdwku5ecb2813z3tz55f1h2rc6vp9fmyp023m7rat](https://confluxscan.net/address/cfx:acdwku5ecb2813z3tz55f1h2rc6vp9fmyp023m7rat)

Conflux Core(测试网):

[cfxtest:achs8uka59jshpez2e0ahmbkuj9gjcghtezgan988u](https://testnet.confluxscan.io/token/cfxtest:achs8uka59jshpez2e0ahmbkuj9gjcghtezgan988u)

## 合约

|                 文件名                  |      概述      |
|:------------------------------------:|:------------:|
| [CRC1155.sol](contracts/CRC1155.sol) | PuerHub Core |

## 读取合约

|         方法          |                 概述                 |
|:-------------------:|:----------------------------------:|
| DEFAULT_ADMIN_ROLE  |              管理员权限常量               |
|     MINTER_ROLE     |              铸造者权限常量               |
|     PAUSER_ROLE     |              暂停者权限常量               |
|      balanceOf      |   因为为非同质化，最大值为 `1`，为 `1` 则代表其拥有    |
|   balanceOfBatch    |         `balanceOf` 的批量查询          |
|       exists        |       查询指定 `tokenId` 是否已铸造存在       |
|    getRoleAdmin     |              查询管理员角色               |
|    getRoleMember    |           查询指定角色指定索引的地址            |
| getRoleMemberCount  |             查询指定角色的成员数             |
|       hasRole       |               是否具有权限               |
|  isApprovedForAll   |               是否允许操作               |
|        name         |                合约名称                |
|  physicalTokenMap   |     查询指定实物 `id` 对应的 `tokenId`      |
|  supportsInterface  |              查询支持的接口               |
|       symbol        |               合约的简称                |
|    tokenByIndex     |         以索引查询对应的 `tokenId`         |
|    tokenCountOf     |         查询指定地址拥有的 token 数量         |
|  tokenFeatureCode   |           token 对应资源的特征码           |
|     tokenFrozen     |          查询指定 token 是否冻结           |
|  tokenFrozenRecord  |          查询指定 token 的冻结次数          |
| tokenOfOwnerByIndex | 查询指定地址，token 索引的数量，因为非同质化，最大值为 `1` |
|  tokenPhysicalMap   |     查询指定 `tokenId` 对应的实物 `id`      |
|       tokens        |    列出指定 offset 和 limit 的 token     | 
|      tokensOf       |          `tokens` 的指定地址查询          |
|   totalSupply 无参    |            发行的 token 总数            |
|     totalSupply     | 指定 `tokenId` 的发行数量，因为非同质化，最大值为 `1` |
|         uri         |        指定 `tokenId` 的元数据链接         |

## 写入合约

|          方法           |         概述          |
|:---------------------:|:-------------------:|
|       addMinter       |   添加指定地址为铸造者，仅管理员   |
|       batchMint       |        批量铸造         |
|         burn          |     销毁，仅拥有者可执行      |
|        freeze         |     冻结，仅拥有者可执行      |
|       grantRole       |    授予指定地址权限，仅管理员    |
|         mint          |         铸造          |
|     removeMinter      |       移除铸造者权限       |
|     renounceRole      |        放弃权限         |
|      revokeRole       |        撤销权限         |
| safeBatchTransferFrom |        批量转移         |
|   safaTransferFrom    |         转移          |
|   setApprovalForAll   |       授予所有操作        |
| setTokenFreatureCode  | 设置 token 的资源特征码，仅一次 |
|        setURI         |   设置 token 的元数据地址   |
|       unfreeze        |       解冻，仅管理员       |
