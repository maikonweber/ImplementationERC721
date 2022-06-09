// SPDX-License-Identifier: MIT

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.7.0 <0.9.0;

contract NFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    // Valor de Cada Mint (Mint Cost)
    //uint256 public cost = 1 ether;
    // Max Supply Permitido para mintar neste contrato  
    uint256 public maxSupply = 10000;

    string baseURI;
    string public baseExtension = ".json";
     
    // com mais artista podem registrar um tokem
    // mapping(address => bool) public registeredArtists;
    address public artist;
    uint256 public royalityFee;

    event Sale(address from, address to, uint256 value);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        uint256 _royalityFee,
        address _artist
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
        royalityFee = _royalityFee;
        artist = _artist;
    }

    // Public functions
    function mint(address from,uint256 amount) public onlyOwner() {
        uint256 supply = totalSupply();
        require(supply <= maxSupply);

        //if (msg.sender != owner()) {
          //  require(msg.value >= cost);

            // Pay royality to artist, and remaining to deployer of contract

            //uint256 royality = (msg.value * royalityFee) / 100;
            //_payRoyality(royality);

            //(bool success2, ) = payable(owner()).call{
           
                
            //}("");
           // require(success2);
        
        // Make a for for amount token and generate _safeMint to address
        for (uint256 i = 0; i < amount; i++) {
            _safeMint(from, supply + i);
        }

    }

    // Função tokenURI para retornar o URI do token
    // Receber um uint do TokenId

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
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable override {   
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        if (msg.value > 0) {

            uint256 royality = (msg.value * royalityFee) / 100;

            _payRoyality(royality);

            (bool success2, ) = payable(from).call{value: msg.value - royality}(
                ""
            );
            require(success2);
            // Emite um evento de venda para from  e to com uma msg.values que eh o valor
            emit Sale(from, to, msg.value);
        }

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable override {
        if (msg.value > 0) {
            uint256 royality = (msg.value * royalityFee) / 100;
            _payRoyality(royality);

            (bool success2, ) = payable(from).call{value: msg.value - royality}(
                ""
            );
            require(success2);

            emit Sale(from, to, msg.value);
        }

        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public payable override {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );

        if (msg.value > 0) {
            uint256 royality = (msg.value * royalityFee) / 100;
            _payRoyality(royality);
            // Emite um evento de venda para from  e to com uma msg.values que eh o valor

            (bool success2, ) = payable(from).call{value: msg.value - royality}(
                ""
            );
            require(success2);

            emit Sale(from, to, msg.value);
        }
        // Função _safeTransfer 
        _safeTransfer(from, to, tokenId, _data);
    }

    // Função interna para que possa visualizar a base Uri pertencente ao tokens
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    // _parRoyality é uma função interna que recebe um valor e o paga para o artista

    // o _payRoyality é uma função interna que recebe um valor e o paga para o artista
    
    function _payRoyality(uint256 _royalityFee) internal {
        (bool success1, ) = payable(artist).call{value: _royalityFee}("");
        require(success1);
    }

    // Função setBaseUri para alterar o baseURI, recebe um string na memoria
    // do contrato e atualiza o baseURI do contrato ela é chamada apenas para os dono do contrato.

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    // Função setRoyalityFee para alterar o RoyalityFee, recebe um uint256 na memori
    // do contrato e atualiza o RoyalityFee do contrato ela é chamada apenas para os dono do contrato.
    function setRoyalityFee(uint256 _royalityFee) public onlyOwner {
        royalityFee = _royalityFee;
    }
}