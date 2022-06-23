// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@confluxfans/contracts/token/CRC1155/presets/CRC1155PresetAutoId.sol";
import "@confluxfans/contracts/token/CRC1155/extensions/CRC1155Metadata.sol";
import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**

  ___              _  _      _
 | _ \_  _ ___ _ _| || |_  _| |__
 |  _/ || / -_) '_| __ | || | '_ \
 |_|  \_,_\___|_| |_||_|\_,_|_.__/

 https://github.com/puerhub/contract
*/


/**
    StringsHelper to convert physical id to uppercase.

    字符串类，用于将实物映射 Id 转换为大写
*/
library StringsHelper {
    /**
     * toUppercase
     *
     * Converts all the values of a string to their corresponding upper case
     * value.
     *
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string base to convert to upper case
     * @return string
    */
    function toUppercase(string memory _base)
    internal
    pure
    returns (string memory)
    {
        bytes memory _baseBytes = bytes(_base);
        for (uint256 i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _upper(_baseBytes[i]);
        }
        return string(_baseBytes);
    }

    /**
     * Upper
     *
     * Convert an alphabetic character to upper case and return the original
     * value when not alphabetic
     *
     * @param _b1 The byte to be converted to upper case
     * @return bytes1 The converted value if the passed value was alphabetic
     *                and in a lower case otherwise returns the original value
    */
    function _upper(bytes1 _b1) private pure returns (bytes1) {
        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1) - 32);
        }

        return _b1;
    }
}

contract CRC1155 is
AccessControlEnumerable,
CRC1155Enumerable,
CRC1155Metadata,
InternalContractsHandler
{
    using Counters for Counters.Counter;
    using StringsHelper for string;
    using Strings for uint256;

    // tokenId => FeatureCode, the Feature code is generally md5 code for resource files such as images or videos.
    // tokenId => 特征码，通常特征码为资源文件 图片或视频的 md5 哈希值
    mapping(uint256 => uint256) public tokenFeatureCode;
    // tokenId => bool, Whether the token is frozen
    // tokenId => bool, tokenId 是否被冻结
    mapping(uint256 => bool) public tokenFrozen;
    // tokenId => Freeze times record
    // tokenId => tokenId 冻结的次数表
    mapping(uint256 => uint256) public tokenFrozenRecord;
    // tokenId => Physical Id, the physical Id is unique map with tea
    // 实物映射 Id => tokenId, tokenId 映射表
    mapping(uint256 => string) public tokenPhysicalMap;
    // Physical Id => tokenId, the physical Id is unique map with tea
    // tokenId => 实物隐射 Id, 实物 Id 映射表
    mapping(string => uint256) public physicalTokenMap;

    // Counter to auto generate token Id.
    // 计数器，用于自动生成 token Id.
    Counters.Counter private _tokenIdTracker;

    // Declaring permission constants
    // 声明权限常量
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    // contract constructor
    // 合约构造器
    constructor(
        string memory name_,
        string memory symbol_,
        string memory uri_
    ) CRC1155Metadata(name_, symbol_) ERC1155(uri_) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    // add a account as minter
    // 为一个账户添加铸造权限
    function addMinter(address minter_) external {
        grantRole(MINTER_ROLE, minter_);
    }

    // remove role miner permissions
    // 移除账户的铸造权限
    function removeMinter(address minter_) external {
        revokeRole(MINTER_ROLE, minter_);
    }

    // freeze token
    // 冻结 token
    function freeze(uint256 tokenId) public virtual {
        require(
            balanceOf(_msgSender(), tokenId) > 0,
            "PuerHub Core: freeze caller is not owner nor approved"
        );
        // 需要 sender 具有此 token 的所有权
        tokenFrozen[tokenId] = true;
        tokenFrozenRecord[tokenId] = tokenFrozenRecord[tokenId] + 1;
    }

    // unfreeze
    // 解冻 token
    function unfreeze(uint256 tokenId) public virtual {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "PuerHub Core: must have admin role to unfreeze"
        );
        // 只有管理者有权限解冻
        tokenFrozen[tokenId] = false;
    }

    /**
     * @dev Destroys `amount` tokens of token type `id` from `from`
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `amount` tokens of token type `id`.
    */
    // burn
    // 销毁
    function burn(uint256 tokenId) public virtual {
        // _burn 判断 sender 所有权
        _burn(_msgSender(), tokenId, 1);
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
    */
    // override safe transfer from
    // 重写 transfer from 方法，判断其是否冻结
    function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data) public virtual override(ERC1155, IERC1155) {
        require(
            !tokenFrozen[tokenId],
            "PuerHub Core: token must to be in the unfrozen state"
        );
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "PuerHub Core: caller is not owner nor approved"
        );
        _safeTransferFrom(from, to, tokenId, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
    */
    // override safe batch transfer from
    // 重写 batch transfer 方法，判断其是否冻结
    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual override(ERC1155, IERC1155) {
        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 tokenId = ids[i];
            require(
                !tokenFrozen[tokenId],
                "PuerHub Core: token must be in an unfrozen state"
            );
        }

        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "PuerHub Core: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Update the URI for all tokens.
     *
     * Requirements:
     *
     * - the caller must have the `DEFAULT_ADMIN_ROLE`.
    */
    // set metadata base uri
    // 设置 metadata 的 uri
    function setURI(string memory newUri) public virtual {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "PuerHub Core: must have admin role to set URI"
        );
        _setURI(newUri);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
    */
    // metadata uri
    // 重写 medata 的 uri 组合为 {uri}/{contractAddress}/{tokenId} 避免不同产商合约之间同 tokenId
    function uri(uint256 tokenId) public view virtual override(ERC1155, IERC1155MetadataURI) returns (string memory) {
        return string(
            abi.encodePacked(
                ERC1155.uri(tokenId),
                tokenPhysicalMap[tokenId]
            )
        );
    }

    /**
     * @dev Creates `amount` new tokens for `to`, of token type `id`.
     *
     * See {ERC1155-_mint}.
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
    */

    // mint
    // 铸造
    function mint(address to, string memory phyId, bytes memory data) public virtual {
        require(bytes(phyId).length == 8,
            "PuerHub Core: physical token id must be 8 bytes"
        );
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "PuerHub Core: must have minter role to mint"
        );
        uint256 tokenId = _tokenIdTracker.current() + 1;
        phyId = phyId.toUppercase();
        require(
            physicalTokenMap[phyId] == 0 && bytes(tokenPhysicalMap[tokenId]).length == 0,
            "PuerHub Core: data already exists in the physical => token map"
        );
        physicalTokenMap[phyId] = tokenId;
        tokenPhysicalMap[tokenId] = phyId;
        _mint(to, tokenId, 1, data);
        _tokenIdTracker.increment();
    }

    // batch mint
    // 批量铸造 (空投)
    function batchMint(address[] calldata _initialOwners, string[] memory _phyIds, bytes memory data) public {
        require(
            _initialOwners.length == _phyIds.length,
            "PuerHub Core: accounts count must == phyIds count"
        );
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "PuerHub Core: must have minter role to mint"
        );
        uint256 _length = _initialOwners.length;
        uint256 tokenId = 0;
        string memory phyId = "";
        for (uint256 i = 0; i < _length; i++) {
            phyId = _phyIds[i].toUppercase();
            require(bytes(phyId).length == 8,
                "PuerHub Core: physical token id must be 8 bytes"
            );
            tokenId = _tokenIdTracker.current() + 1;
            require(
                physicalTokenMap[phyId] == 0 && bytes(tokenPhysicalMap[tokenId]).length == 0,
                "PuerHub Core: data already exists in the physical => token map"
            );
            _mint(_initialOwners[i], tokenId, 1, data);
            physicalTokenMap[phyId] = tokenId;
            tokenPhysicalMap[tokenId] = phyId;
            _tokenIdTracker.increment();
        }
    }

    // Optional functions: The feature code can only be set once for each id, and then it can never be change again
    // 可选函数 设置一次 token 的特征码
    function setTokenFeatureCode(uint256 tokenId, uint256 featureCode) public virtual
    {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "PuerHub Core: must have minter role to set"
        );
        require(
            tokenFeatureCode[tokenId] == 0,
            "PuerHub Core: token Feature Code is already set up"
        );
        tokenFeatureCode[tokenId] = featureCode;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
    */
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, CRC1155Enumerable, IERC165) returns (bool)
    {
        return
        AccessControlEnumerable.supportsInterface(interfaceId) ||
        CRC1155Enumerable.supportsInterface(interfaceId);
    }
}
