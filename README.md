# Implementação do Token 721 - Aleatório com Tiragem

Este projeto demonsta um avaçado caso de uso de hardhat, Instegração de ferramentas comumn usadas no exosystema hardhat.

Este projeto vem com uma amostra decontract, Um teste para este contrato, um script de deploys deste  contract, e um example de uma rotina de implementação, que lista as contas. tambem esta incluso a varias de outras ferramentas, configure seu trabalho com este commandos

- Será necessário o node 14.17 ou 16.10

- npm -i hardhat -g // Para instalar o Hardhat de forma global
- npm -i // Para instalar todas dependecias no packge.json


*** npx hardhat node // Iniciará um rede Ganache para testar os Contratos
*** npx hardhat test // Iniciará os test 
*** npx hardhat run // url do script faz deploy do contrato.

/ REPORT_GAS=true npx hardhat test // Realiza os test com Gas Report 


Alguns comandos disponíveis: 


```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```