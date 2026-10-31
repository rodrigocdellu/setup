# 🛠️ Development Environment Setup

Repositório dedicado à documentação, configuração e manutenção do meu ambiente pessoal de desenvolvimento de software, com foco em **Windows 11 ARM64**.

O objetivo é manter um ambiente de desenvolvimento organizado, consistente, reproduzível e preparado para trabalhar com diferentes tecnologias e projetos de software.

## 🎯 Objetivos

Este repositório centraliza os recursos necessários para configurar e manter o ambiente de desenvolvimento, incluindo:

- Documentação das ferramentas e tecnologias utilizadas.
- Procedimentos de instalação e configuração.
- Organização das configurações do ambiente.
- Padronização das ferramentas de desenvolvimento.
- Manutenção e evolução da infraestrutura local.
- Backup automatizado dos arquivos do repositório.

## 📦 Estrutura do Repositório

| Diretório / Arquivo | Descrição |
|---|---|
| `CONFIGURAR_AMBIENTE_DESENVOLVIMENTO_WINDOWS11_ARM64/` | Documentação e recursos para configuração do ambiente Windows 11 ARM64. |
| `.github/workflows/` | Automações executadas pelo GitHub Actions. |
| `README.md` | Documentação geral do repositório. |
| `LICENSE` | Licença MIT. |

## 💻 Plataforma de Desenvolvimento

A plataforma de referência deste repositório é:

| Componente | Configuração |
|---|---|
| Sistema operacional | Windows 11 |
| Arquitetura | ARM64 |
| Repositório de código | GitHub |
| Controle de versão | Git |
| Automação | GitHub Actions |

As configurações específicas das ferramentas, dependências e componentes do ambiente devem ser documentadas no diretório correspondente à plataforma.

## 🚀 Configuração do Ambiente

### Pré-requisitos

- Computador compatível com Windows 11 ARM64.
- Acesso à Internet.
- Permissões necessárias para instalação e configuração de ferramentas.

### Obter o Repositório

Clone o repositório:

```bash
git clone https://github.com/rodrigocdellu/setup.git
```

Acesse o diretório:

```bash
cd setup
```

### Consultar as Instruções de Configuração

Acesse o diretório:

```text
CONFIGURAR_AMBIENTE_DESENVOLVIMENTO_WINDOWS11_ARM64/
```

Consulte a documentação correspondente para conhecer os procedimentos de instalação, configuração e utilização do ambiente.

## ⚙️ Automação e Backup

O repositório utiliza GitHub Actions para automatizar o backup dos arquivos no Dropbox.

### Funcionamento

- **Execução automática:** após atualizações na branch `main`.
- **Execução manual:** disponível pela interface do GitHub Actions.
- **Destino:** armazenamento no Dropbox.
- **Formato:** arquivo ZIP contendo os arquivos versionados, sem incluir o diretório `.git`.
- **Autenticação:** utiliza o segredo `DROPBOX_ACCESS_TOKEN`, configurado nas configurações do repositório GitHub.

A automação permite manter uma cópia externa dos arquivos, complementando o histórico de versionamento do GitHub.

## 🔄 Manutenção

Este repositório é mantido continuamente para acompanhar a evolução do ambiente de desenvolvimento.

As atualizações podem envolver:

- Inclusão ou remoção de ferramentas.
- Atualização de versões de softwares e dependências.
- Revisão dos procedimentos de instalação.
- Melhorias nas configurações existentes.
- Aperfeiçoamento das automações.
- Correção de problemas de compatibilidade.

Sempre que possível, as alterações devem preservar a consistência e a capacidade de reconstrução do ambiente.

## 🤝 Contribuições

Este é um repositório de configuração pessoal, mas sugestões de melhorias e correções são bem-vindas.

## 📄 Licença

Este projeto está licenciado sob os termos da MIT License. Para mais informações, consulte o arquivo `LICENSE`.

---

**Maintainer:** [Rodrigo C. Dellu](https://github.com/rodrigocdellu)

**Repositório:** https://github.com/rodrigocdellu/setup