# PuerHub Smart Contract

English | [简体中文](README-zh.md)

[![Node.js CI](https://github.com/PuerHub/contract/actions/workflows/node.yml/badge.svg)](https://github.com/PuerHub/contract/actions/workflows/node.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Conflux Form](https://img.shields.io/badge/Conflux-Forum-brightgreen)](https://forum.conflux.fun/t/137-puerhub-l1/15270)

Conflux Core(Hydra):

[cfx:acdwku5ecb2813z3tz55f1h2rc6vp9fmyp023m7rat](https://confluxscan.net/address/cfx:acdwku5ecb2813z3tz55f1h2rc6vp9fmyp023m7rat)

Conflux Core(Testnet):

[cfxtest:achs8uka59jshpez2e0ahmbkuj9gjcghtezgan988u](https://testnet.confluxscan.io/token/cfxtest:achs8uka59jshpez2e0ahmbkuj9gjcghtezgan988u)

## Contract

|               FileName               |   Summary    |
|:------------------------------------:|:------------:|
| [CRC1155.sol](contracts/CRC1155.sol) | PuerHub Core |

## Read Contract

|          Method          |                                                      Summary                                                      |
|:------------------------:|:-----------------------------------------------------------------------------------------------------------------:|
|    DEFAULT_ADMIN_ROLE    |                                         Administrator privilege constant                                          |
|       MINTER_ROLE        |                                            minter permission constant                                             |
|       PAUSER_ROLE        |                                             Pause Permission Constant                                             |
|        balanceOf         |                   Because it is non-homogeneous, the maximum value is `1`, and `1` means it has                   |
|      balanceOfBatch      |                                            Batch query for `balanceOf`                                            |
|          exists          |                               Query whether the specified `tokenId` has been minted                               |
|       getRoleAdmin       |                                             Query administrator roles                                             |
|      getRoleMember       |                          Query the address of the specified index of the specified role                           |
|    getRoleMemberCount    |                                 Query the number of members of the specified role                                 |
|         hasRole          |                                                  Has permission                                                   |
|     isApprovedForAll     |                                         Whether the operation is allowed                                          |
|           name           |                                                   Contract name                                                   |
|     physicalTokenMap     |                         Query the `tokenId` corresponding to the specified physical `id`                          |
|    supportsInterface     |                                            Query supported interfaces                                             |
|          symbol          |                                             Abbreviation of contract                                              |
|       tokenByIndex       |                                    Query the corresponding `tokenId` by index                                     |
|       tokenCountOf       |                             Query the number of tokens owned by the specified address                             |
|     tokenFeatureCode     |                            The feature code of the resource corresponding to the token                            |
|       tokenFrozen        |                                    Query whether the specified token is frozen                                    |
|    tokenFrozenRecord     |                             Query the number of freezing times of the specified token                             |
|   tokenOfOwnerByIndex    | Query the specified address, the number of token indexes, because of non-homogenization, the maximum value is `1` |
|     tokenPhysicalMap     |                         Query the physical `id` corresponding to the specified `tokenId`                          |
|          tokens          |                                    List tokens with specified offset and limit                                    |
|         tokensOf         |                                         `tokens` specified address query                                          |
| totalSupply No parameter |                                           Total number of issued tokens                                           |
|       totalSupply        |         Specifies the number of `tokenId` issued, because of non-homogenization, the maximum value is `1`         |
|           uri            |                                   Specifies the metadata link for the `tokenId`                                   |

## Write Contract

|        Method         |                           Summary                            |
|:---------------------:|:------------------------------------------------------------:|
|       addMinter       |         Add specified address as minter, admin only          |
|       batchMint       |                          Batch Mint                          |
|         burn          |              Destroy, only the owner can do it               |
|        freeze         |             Freeze, executable only by the owner             |
|       grantRole       | Grants the specified address permission, only administrators |
|         mint          |                           casting                            |
|     removeMinter      |                   Remove miner permissions                   |
|     renounceRole      |                    Relinquish permissions                    |
|      revokeRole       |                      Revoke permissions                      |
| safeBatchTransferFrom |                        batch transfer                        |
|   safaTransferFrom    |                           Transfer                           |
|   setApprovalForAll   |                    Approve all operations                    |
| setTokenFreatureCode  |    Set the resource feature code of the token, only once     |
|        setURI         |            Set the metadata address of the token             |
|       unfreeze        |                     unfreeze, admin only                     |
