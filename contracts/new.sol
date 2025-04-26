// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NftMinting is ERC721, ReentrancyGuard, PaymentSplitter, Ownable {
    bytes32 immutable merkleRoot;
    string private baseURI;

    bool public isPaused;
    bool public isPreSaleActive;
    bool public isPublicSaleActive;

    uint256 currentTokenId;

    uint256 public constant PRESALE_LIMIT = 5;
    uint256 public constant NFT_MINTING_PRICE = 0.01 ether;
    uint256 public constant MAX_SUPPLY = 20;

    address[] private teamMembers = [
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    ];
    uint256[] private teamShares = [20, 40, 40];

    mapping(address => uint256) public presaleCount;
    mapping(uint256 => string) public tokenCids;

    modifier onlyEOA() {
        require(tx.origin == msg.sender, "Contract calls not allowed");
        _;
    }

    modifier isVerified(bytes32[] calldata proof) {
        require(
            MerkleProof.verify(
                proof,
                merkleRoot,
                keccak256(abi.encodePacked((msg.sender)))
            ),
            "Proof not valid"
        );
        _;
    }

    constructor(string memory initialBaseURI, bytes32 root)
        ERC721("NEW NFT", "NNT")
        Ownable(msg.sender)
        ReentrancyGuard()
        PaymentSplitter(teamMembers, teamShares)
    {
        baseURI = initialBaseURI;
        merkleRoot = root;
    }

    function togglePreSale() external onlyOwner {
        isPreSaleActive = !isPreSaleActive;
    }

    function togglePublicSale() external onlyOwner {
        isPublicSaleActive = !isPublicSaleActive;
    }

    function preSaleMint(
        uint256 nftAmount,
        bytes32[] calldata proof,
        string[] calldata cids
    ) external payable onlyEOA nonReentrant isVerified(proof) {
        require(isPublicSaleActive == true, "Contract not active");
        require(isPreSaleActive == true, "Presale not active");
        require(nftAmount > 0, "nftAmount > 0");
        require(
            presaleCount[msg.sender] + nftAmount <= PRESALE_LIMIT,
            "PRESALE_LIMIT exceed"
        );
        require(currentTokenId + nftAmount <= MAX_SUPPLY, "MAX_SUPPLY exceed");
        require(cids.length == nftAmount, "Contract not active");
        require(
            msg.value == nftAmount * NFT_MINTING_PRICE,
            "Not enough ethers"
        );

        presaleCount[msg.sender] += nftAmount;

        for (uint256 i = 0; i < nftAmount; i++) {
            _mintToken(msg.sender, cids[i]);
        }
    }

    function _mintToken(address to, string calldata cid) internal {
        _safeMint(to, currentTokenId);
        tokenCids[currentTokenId] = cid;
        currentTokenId++;
    }

    function publicSaleMint(uint256 nftAmount, string[] calldata cids)
        external
        payable
        onlyEOA
        nonReentrant
    {
        require(!isPaused, "Contract: Paused");
        require(isPublicSaleActive, "Public sale is not active");
        require(nftAmount > 0, "Amount must be greater than zero");
        require(
            currentTokenId + nftAmount <= MAX_SUPPLY,
            "Max supply exceeded"
        );
        require(cids.length == nftAmount, "CIDs and nftAmount mismatched");
        require(
            msg.value == nftAmount * NFT_MINTING_PRICE,
            "Not enough ethers"
        );

        for (uint256 i = 0; i < nftAmount; i++) {
            _mintToken(msg.sender, cids[i]);
        }
    }

    function setCid(uint256 tokenId, string calldata cid) external {
        require(msg.sender == _requireOwned(tokenId));
        tokenCids[tokenId] = cid;
    }

    function totalSupply() external view returns (uint256) {
        return currentTokenId;
    }

    function remainingSupply() external view returns (uint256) {
        return MAX_SUPPLY - currentTokenId;
    }

    function withdrawEther() external payable onlyOwner {
        require(address(this).balance > 0, "Contract has zero balance");
        payable(msg.sender).transfer(address(this).balance);
    }
}

//["bafkreibmzyvd4fcwdxsrydkpjq7cdg7o3nslpuxmq3fwfstbpnuk3qqclq","QmQNuYc7xXY62v6jVfFz2NoZMWZzeejTTB3Ke223aS7DqD"]
