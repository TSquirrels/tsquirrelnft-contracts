pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

contract TSquirrelNFT is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, OwnableUpgradeable, PausableUpgradeable {

    uint256 public maxSupply;
    uint256 public mintPrice; // 30 TLOS
    string public baseURI;

    /// @dev constructor replacement for proxy call
    /// @param name_ new name of token
    /// @param symbol_ symbol of token
    /// @param mintPrice_ mint price of token
    /// @param maxSupply_ max supply of token
    function initialize(string memory name_, string memory symbol_, uint256 mintPrice_, uint256 maxSupply_) initializer public {
        __ERC721_init(name_, symbol_);
        __ERC721Enumerable_init();
        __Ownable_init();
        maxSupply = maxSupply_;
        mintPrice = mintPrice_;
        _pause();
    }

    /// @dev toggles paused state
    function togglePaused() public onlyOwner {
        if (paused()) {
            _unpause();
        } else {
            _pause();
        }
    }

    /// @dev mints the next tokenId to msg.sender if min value is paid
    function mint() public payable whenNotPaused {
        //validate
        require(msg.value == mintPrice, "Must send exact value to mint");
        require(ERC721EnumerableUpgradeable.totalSupply() < maxSupply, "Max supply has been reached, no more mints are possible");

        //send eth to owner address
        (bool sent, bytes memory data) = owner().call{value: msg.value}("");
        require(sent, "Failed to send to owner address");

        _safeMint(msg.sender, ERC721EnumerableUpgradeable.totalSupply());
    }

    /// @dev sets a new mintPrice value
    /// @param newMintPrice value of new mintPrice
    function setMintPrice(uint256 newMintPrice) public onlyOwner {
        mintPrice = newMintPrice;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /// @dev sets a new baseURI for contract
    /// @param newBaseURI new baseURI to set
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    /// @dev overridden ERC721Metadata function to return baseURI
    /// @return baseURI string
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /// @dev overridden ERC721, ERC721Enumerable function
    function supportsInterface(bytes4 interfaceId) public view override(ERC721Upgradeable, ERC721EnumerableUpgradeable) returns (bool) {
       return super.supportsInterface(interfaceId);
    }
}
