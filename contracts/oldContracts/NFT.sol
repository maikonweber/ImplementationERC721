// SPDX-License-Identifier: MIT

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.7.0 <0.9.0;

contract NFT is ERC721Enumerable, Ownable  {
    using Strings for uint256;

    // Valor de Cada Mint (Mint Cost)
    //uint256 public cost = 1 ether;
    // Max Supply Permitido para mintar neste contrato  
    uint256 public maxSupply = 10000;
    uint256 public minimuPrice = 2 ether;
    string baseURI;
    string public baseExtension = ".json";
    bool public isMintable = true;
    // com mais artista podem registrar um tokem
    // mapping(address => bool) public registeredArtists;
    uint256 public royalityFee;
    address[] public artists;
    event Sale(address from, address to, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        uint256 _royalityFee,
        address[] memory _artists
    ) ERC721 (_name, _symbol) {
        setBaseURI(_initBaseURI);
        royalityFee = _royalityFee;
        artists = _artists;
        
    }

    // Public functions
    function seeArtictsArray() public view returns (address[] memory) {
        return artists;
    }

    function isArtist(address _sender) public view returns (bool) {
        // If address inside artists array, return true
        for (uint256 i = 0; i < artists.length; i++) {
            if (artists[i] == _sender) {
                return true;
            }
        }
    }


    function mint(address from, uint32 amount) public {
        uint256 supply = totalSupply();
        require(supply <= maxSupply);
        require(amount > 0);
        // if msg sender is not an artist, then he can't mint
        // if msg sender is not an artist, then he can't mint
        require(isArtist(msg.sender));

        
        for(uint256 i = 0; i < amount; i++) {
            _safeMint(from, supply + i);
            // Pay the fee
            }
        }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            // Conversao caso o tokenId seja maior que uint256
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }
    //transferFrom é um overide da função da classe ERC721
    // Receber um address do owner, um address do to, um uint do tokenId
    // ele tem o metodo require que verifica se é o dono do mesmo e se o tokenId existe
    // caso a msg.valure for maior que 0 
    
    // function transferFrom(address from, address to, uint256 tokenId)
    //  ERC721 (from, to, tokenId) override ERC721 and ERC721
    function royalticTransfer(address from,  address to, uint256 tokenId) 
        public 
        payable
    {
         require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        if (msg.value > minimuPrice) {
            uint256 royality = (msg.value * royalityFee) / 100;
            _payRoyality(royality);

            (bool success2, ) = payable(from).call{value: msg.value - royality}("");
            require(success2);
            emit Sale(from, to, msg.value);    
        }

        _transfer(from, to, tokenId);

    }   

    // See valor of royaltics fee
    function getRoyalityFee() public view returns (uint256) {
        return royalityFee;
    }


    // Função interna para que possa visualizar a base Uri pertencente ao tokens
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    // _parRoyality é uma função interna que recebe um valor e o paga para o artista

    // o _payRoyality é uma função interna que recebe um valor e o paga para o artista
    
    function _payRoyality(uint256 _royalityFee) internal {
        // Dividir a Royaltic fee pelo numero de artistas
        uint256 artistFee = _royalityFee / artists.length;
        // Para cada artista ele paga a Royaltic fee
        // Require all payments to artist Complet
        for (uint256 i = 0; i < artists.length; i++) {
            (bool success, ) = payable(artists[i]).call{value: artistFee}(
                ""
            );
            require(success);
        }
    }

    // Função setBaseUri para alterar o baseURI, recebe um string na memoria
    // do contrato e atualiza o baseURI do contrato ela é chamada apenas para os dono do contrato.

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    // Function to see royalties fees and artist of contract
    function seeRoyalties() public view returns (uint256, address[] memory) {
        return (royalityFee, artists);
    }
     
    // Função setRoyalityFee para alterar o RoyalityFee, recebe um uint256 na memori
    // do contrato e atualiza o RoyalityFee do contrato ela é chamada apenas para os dono do contrato.
    function setRoyalityFee(uint256 _royalityFee) public onlyOwner {
        royalityFee = _royalityFee;
    }
}