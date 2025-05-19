# Conversor de Números Arábicos x Romanos #

![ABAP](https://img.shields.io/badge/ABAP-0061AF?style=flat&logo=sap&logoColor=white)
![SAP](https://img.shields.io/badge/SAP-0FAAFF?style=flat&logo=sap&logoColor=white)
![Development](https://img.shields.io/badge/development-abap-blue?style=flat&logo=sap)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

## 📋 Sobre o Projeto

Desenvolvimento de um programa ABAP para conversão bidirecional entre números arábicos e romanos. O programa oferece:
- Conversão de números arábicos para romanos
- Conversão de números romanos para arábicos
- Interface simples com campo de entrada
- Opção de escolha do tipo de conversão

## 🛠️ Tecnologias

![Eclipse](https://img.shields.io/badge/Eclipse%20ADT-2C2255?style=flat&logo=eclipse&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=flat&logo=github&logoColor=white)

## 📊 Status do Projeto

![Commits](https://img.shields.io/github/commit-activity/m/edmilson-nascimento/Romano)
![Last Commit](https://img.shields.io/github/last-commit/edmilson-nascimento/Romano)
![Issues](https://img.shields.io/github/issues/edmilson-nascimento/Romano)
![Pull Requests](https://img.shields.io/github/issues-pr/edmilson-nascimento/Romano)
![Repository Size](https://img.shields.io/github/repo-size/edmilson-nascimento/Romano)

## 💻 Implementação

O programa utiliza uma tabela de referência com valores correspondentes para cada número. A implementação é feita através do método `constructor`:

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

## 🎯 Objetivo

O objetivo principal foi desenvolver um algoritmo próprio para conversão, sem utilizar rotinas existentes, demonstrando a capacidade de criar soluções personalizadas.

## 📝 Notas de Desenvolvimento

- Implementação inicial focada na funcionalidade básica
- Possibilidade de melhorias futuras aplicando o _SRP — Princípio da Responsabilidade Única_
- Código desenvolvido originalmente para uma entrevista técnica
