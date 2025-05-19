# Conversão de Arábico x Romano ou Romano x Arábico #

![ABAP](https://img.shields.io/badge/ABAP-0061AF?style=for-the-badge&logo=sap&logoColor=white)
![SAP](https://img.shields.io/badge/SAP-0FAAFF?style=for-the-badge&logo=sap&logoColor=white)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)
![Eclipse](https://img.shields.io/badge/Eclipse%20ADT-2C2255?style=for-the-badge&logo=eclipse&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)
![Commits](https://img.shields.io/github/commit-activity/m/EdmilsonNascimento/Romano)
![Last Commit](https://img.shields.io/github/last-commit/EdmilsonNascimento/Romano)
![Issues](https://img.shields.io/github/issues/EdmilsonNascimento/Romano)
![Pull Requests](https://img.shields.io/github/issues-pr/EdmilsonNascimento/Romano)
![Repository Size](https://img.shields.io/github/repo-size/EdmilsonNascimento/Romano)

Afim de atender a necessidade de uma entrevista, foi preciso que eu fizesse um programa que "_... faça conversão de números arábicos para números romanos e o contrário. O Programa não precisa ter nada de especial, apenas uma tela com um input que o usuário insere somente números e alguma forma para escolher qual a conversão que deverá acontecer, Arábico x Romano ou Romano x Arábico_". ~Infelizmente não passei na entrevista devido a uma divergência de aplicação de técnica ABAP em Tabelas Internas, que eu ainda insisto que a pessoa que me entrevistou estava um pouco desatenta aos seus próprios códigos~. Como eu fiquei contente com meu código, resolvi deixar disponível. Para este, é usada uma tabela de referência com o valor correspondente de cada número onde podem ser adicionados mais opções. Esta ação é feita no método `constructor` .

```abap
  method constructor .

    referencia =
      value #(
        ( arabico = 1     romano = 'I' )
        ( arabico = 5     romano = 'V' )
        ( arabico = 10    romano = 'X' )
        ( arabico = 50    romano = 'L' )
        ( arabico = 100   romano = 'C' )
        ( arabico = 500   romano = 'D' )
        ( arabico = 1000  romano = 'M' )
      ) .

    loop at referencia assigning field-symbol(<line>) .

*     Item anterior
      data(index) = sy-tabix - 1 .
      read table referencia into data(line) index index .
      if sy-subrc eq 0 .
        <line>-anterior = line-romano .
      endif .

*     Próximo item
      index = index + 2 .
      read table referencia into line index index .
      if sy-subrc eq 0 .
        <line>-proximo = line-romano .
      endif .

    endloop.
```

O intuito principal foi fazer a conversão sem que fosse utilizada alguma rotina já existente. Eu não pretendia _colocar em check_ o melhor algoritmo para conversão, mas sim, mostrar a minha habilidade de criar um algoritmo assim.
 
Poderia ter feito com uma melhor arquitetura respeitando melhor _SRP — O Princípio da Responsabilidade Única_, e possivelmente vou melhorar usando esse conceito ~~quando tiver tempo e um ambiente descente~~.
