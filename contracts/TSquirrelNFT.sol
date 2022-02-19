// "SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";


contract TSquirrelNFT is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, PausableUpgradeable, OwnableUpgradeable {

    uint256 public maxSupply;
    uint256 public mintPrice; // 30 TLOS
    string public baseURI;
    string public baseFolder;

     using CountersUpgradeable for CountersUpgradeable.Counter;

     CountersUpgradeable.Counter private _tokenIdCounter;

     /// @custom:oz-upgrades-unsafe-allow constructor
     constructor() initializer {}

    function initialize(string memory name_, string memory symbol_, uint256 mintPrice_, uint256 maxSupply_, string[] memory tokenURIList_) initializer public {
            __ERC721_init(name_, symbol_);
            __ERC721Enumerable_init();
            __ERC721URIStorage_init();
            __Pausable_init();
            __Ownable_init();
            tokenURIList = tokenURIList_;
            for (uint i; i < tokenURIList_.length; i++) {
                _tokenURIs[i] = tokenURIList_[i];
            }
            maxSupply = maxSupply_;
            mintPrice = mintPrice_;
            _pause();
         }

         function pause() public onlyOwner {
             _pause();
         }

        /// @dev sets a new maxSupply for contract
        /// @param newMaxSupply new maxSupply to set
        function setMaxSupply(string memory newMaxSupply) external onlyOwner {
            require(newMaxSupply >= ERC721EnumerableUpgradeable.totalSupply(), "Must set max supply higher than current total supply");
            maxSupply = newMaxSupply;
        }

        /// @dev sets a new baseFolder for contract
        /// @param newBaseFolder new baseFolder to set
        function setBaseFolder(string memory newBaseFolder) external onlyOwner {
            baseFolder = newBaseFolder;
        }

        /// @dev sets a new baseURI for contract
        /// @param newBaseURI new baseURI to set
        function setBaseURI(string memory newBaseURI) external onlyOwner {
            baseURI = newBaseURI;
        }

        /// @dev overridden ERC721Metadata function to return baseURI
        /// @return baseURI string
        function _baseURI() internal view override returns (string memory) {
            return baseURI;
        }

         function unpause() public onlyOwner {
             _unpause();
         }

        /// @dev toggles paused state
        function togglePaused() external onlyOwner {
            if (paused()) {
                _unpause();
            } else {
                _pause();
            }
        }

        /// @dev mints the next tokenId to msg.sender if min value is paid
        function mint() external payable whenNotPaused {
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
        function setMintPrice(uint256 newMintPrice) external onlyOwner {
            mintPrice = newMintPrice;
        }

         function _beforeTokenTransfer(address from, address to, uint256 tokenId)
             internal
             whenNotPaused
             override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
         {
             super._beforeTokenTransfer(from, to, tokenId);
         }

         // The following functions are overrides required by Solidity.
         function _burn(uint256 tokenId)
             internal
             override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
         {
             super._burn(tokenId);
         }

        /// @dev adds a new tokenURI for contract
        /// @param newTokenURI new tokenURI to set
        function setTokenURI(uint256 tokenId, string memory newTokenURI) external onlyOwner {
             requires(tokenId < maxSupply, "Token ID cannot exceed max supply");
             _tokenURIs[tokenId] = newTokenURI
        }

        /// @dev tokens that have a set URI should load it from the list
        /// @param tokenId the token id we want the URI for
         function tokenURI(uint256 tokenId)
             public
             view
             override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
             returns (string memory)
         {
             requires(_exists(tokenId), "Token does not exist");
             string memory _tokenURI = _tokenURIs[tokenId];
             if(bytes(_tokenURI).length > 0){
                return string(abi.encodePacked(_baseURI(), _tokenURI));
             }
             return string(abi.encodePacked(_baseURI(), baseFolder, tokenId, '.json');
         }

         function supportsInterface(bytes4 interfaceId)
             public
             view
             override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
             returns (bool)
         {
             return super.supportsInterface(interfaceId);
         }
}
