## 1. Trab

**Curso**: Engenharia da computação
**Disciplina**: Sistemas Operacionais ("IBM0791")  
**Semestre**: 1º Semestre de 2025  
**Professor**: Luiz Fernando T. de Farias  
**Alunos**:  
- Breno Huf - Matrícula: 202209083149  
- Henrique Barbosa - Matrícula: 202208818609  

---

## 2. Introdução

Este trabalho tem como objetivo desenvolver um script bash. 
A escolha das funcionalidades seguiu os criterios na proposta do trabalho, cobrindo comandos basicos, avançados, de sistema de arquivos e gerenciamento de usuarios.

---

## 3. Descrição Técnica

### Menu Principal

O script inicia com a exibição de um cabeçalho, contendo informações da disciplina, equipe, semestre atual, data e hora do sistema, seguido de um menu com cinco opções:

1. Exibir data e hora atuais
2. Mover arquivo para outro diretório
3. Realizar backup de diretório
4. Criar novo usuário com informações adicionais
5. Finalizar o script

A cada execução de uma opção, o menu é reapresentado até que a opção 5 seja escolhida.

### Estrutura de Arquivos

- `trab.sh`: script principal
- `op.sh`: funções auxiliares chamadas pelo `trab.sh`
- `menu_escolhas.txt`, `tabela1.txt`, `tabela2.txt`: dados do cabeçalho e menu

### Detalhamento das Funções

#### `op1()`
- Exibe data e hora no formato: `EX: Segunda-feira, 08 de Junho de 2025, 08:30:00`

#### `op2()`
- Solicita o caminho de um arquivo e de um diretório de destino.
- Valida a existência dos dois.
- Move o arquivo usando `mv`.

#### `op3()`
- Solicita diretório para backup.
- Cria backup com `cp -r` em pasta nomeada com timestamp.

#### `op4()`
- Verifica se o script está sendo executado como root.
- Solicita dados de um novo usuário (nome completo, sala, telefones etc.)
- Cria o usuário com `adduser` e o adiciona ao grupo `sudo`.

---

## 4. Pseudocódigo

```plaintext
INICIAR trab.sh
    ENQUANTO verdadeiro
        clear
        Exibir cabeçalho (tabela1.txt + semestre atual + tabela2.txt)
        Exibir data e hora atual formatados
        Exibir menu (menu_escolhas.txt)
        Ler opção do usuário
        CASO opção seja:
            1 -> chamar op1
            2 -> chamar op2
            3 -> chamar op3
            4 -> chamar op4
            5 -> sair
            outro -> mensagem de erro
        Esperar tecla para continuar
    FIM
````

---

## 5. Comandos Bash Utilizados

* `date`: para data e hora
* `mv`: mover arquivos
* `cp -r`: copiar diretórios recursivamente
* `adduser`, `usermod`: gerenciamento de usuários
* `basename`, `dirname`: manipulação de caminhos
* `read`: entrada do usuário
* `clear`: limpar a tela
* `if`, `case`, `while`, `function`: estruturas de controle

---

## 6. Testes Realizados

### **Teste 1 – Exibir Data e Hora Atual**

**Objetivo:** Verificar se a função `op1()` exibe corretamente a data e a hora atuais no formato especificado.
**Entrada:** Seleção da opção `1` no menu.
**Pré-condições:** Nenhuma.
**Ações executadas:**

* O script chama o comando `date` com a formatação `"%A, %d de %B de %Y, %H:%M:%S"`.

**Resultado esperado:**

* Impressão no terminal de uma string com a data e hora formatadas, por exemplo:

  ```
  Data e hora atual: sábado, 08 de junho de 2025, 14:23:45
  ```

---

### **Teste 2 – Mover Arquivo**

**Objetivo:** Verificar se a função `op2()` move corretamente um arquivo para um diretório válido.
**Entrada:**

* Caminho válido de um arquivo existente.
* Caminho válido de um diretório de destino.

**Pré-condições:**

* O arquivo de origem deve existir.
* O diretório de destino deve existir.

**Ações executadas:**

* Verificação da existência do arquivo (`-f`) e do diretório (`-d`).
* Comando `mv` para mover o arquivo.

**Resultado esperado:**

* Se tudo for válido, exibe:

  ```
  Arquivo movido com sucesso para '<diretório>'.
  ```
* Se houver erro, exibe mensagens adequadas como:

  ```
  Erro: O arquivo '...' não existe.
  Erro: O diretório '...' não existe.
  Erro ao mover o arquivo.
  ```

---

### **Teste 3 – Backup de Diretório**

**Objetivo:** Verificar se a função `op3()` cria corretamente uma cópia de backup de um diretório.
**Entrada:** Caminho de um diretório existente contendo arquivos.
**Pré-condições:**

* O diretório fornecido deve existir.
* Deve haver permissão de leitura no diretório.

**Ações executadas:**

* Geração de um timestamp com `date`.
* Criação do caminho `backup_<nome>_<timestamp>`.
* Uso de `cp -r` para copiar todo o conteúdo.

**Resultado esperado:**

* Diretório de backup criado no mesmo local que o diretório original, com nome contendo prefixo `backup_` e o timestamp.
* Mensagem de sucesso:

  ```
  Backup do diretório '<origem>' concluído com sucesso em 'backup_<nome>_<timestamp>'
  ```

---

### **Teste 4 – Criar Usuário (como root)**

**Objetivo:** Testar a função `op4()` para criação de novo usuário com informações adicionais e inclusão no grupo sudo.
**Entrada:**

* Nome de usuário.
* Informações GECOS (nome completo, sala, telefone etc.).
* Confirmação de definição de senha.

**Pré-condições:**

* O script deve ser executado com privilégios de root (`EUID == 0`).
* O nome de usuário não deve existir previamente.

**Ações executadas:**

* Verificação se o usuário já existe com `id`.
* Execução do comando `adduser` com campo GECOS.
* Adição ao grupo `sudo` com `usermod -aG sudo`.

**Resultado esperado:**

* Usuário criado com sucesso.
* Se confirmado, senha definida.
* Mensagem final:

  ```
  Usuário '<nome>' foi criado e adicionado ao grupo 'sudo'.
  ```
* Mensagens de erro podem ocorrer se:

  * O script não for root.
  * O usuário já existir.
  * `adduser` falhar.

---

## 7. Conclusões

O script atendeu a os requisitos propostos. As principais dificuldades envolveram problemas de sintaxe e formatação da interface, superadas com testes iterativos.

---

## 8. Código-Fonte (Comentado)

### `trab.sh`

```bash
#!/bin/bash
# Script principal do projeto

source op.sh  # Importa funções

while true; do
    clear

    cat tabela1.txt

    # Determina semestre com base no mês atual
    ano=$(date +%Y)
    mes=$(date +%m)
    if [ "$mes" -le 6 ]; then
      semestre=1
    else
      semestre=2
    fi

    echo "# ${semestre}º Semestre de ${ano}                                      #"
    cat tabela2.txt

    # Data e hora
    DATA=$(date +"%d/%m/%Y")
    HORA=$(date +"%H:%M:%S")
    echo "Rio de Janeiro \"$DATA\". \"$HORA\"."

    # Menu
    cat menu_escolhas.txt
    read -rp "Escolha uma opção: " OPCAO

    case "$OPCAO" in
        1) op1 ;;
        2) op2 ;;
        3) op3 ;;
        4) op4 ;;
        5) echo "Saindo..."; break ;;
        *) echo "Opção inválida. Tente novamente." ;;
    esac

    echo "Aperte qualquer tecla para voltar para o menu"
    read -n 1 -s
done
```

### `op.sh`

```bash
#!/bin/bash

# Opção 1: Exibe data e hora
op1() {
    echo "Data e hora atual: $(date +"%A, %d de %B de %Y, %H:%M:%S")"
}

# Opção 2: Move arquivo
op2() {
    read -rp "Digite o caminho do arquivo: " ARQUIVO_ORIGEM
    if [ ! -f "$ARQUIVO_ORIGEM" ]; then
        echo "Erro: Arquivo inexistente."
        return 1
    fi
    read -rp "Digite o diretório destino: " DIRETORIO_DESTINO
    if [ ! -d "$DIRETORIO_DESTINO" ]; then
        echo "Erro: Diretório inexistente."
        return 1
    fi
    mv "$ARQUIVO_ORIGEM" "$DIRETORIO_DESTINO" && echo "Movido com sucesso." || echo "Erro ao mover."
}

# Opção 3: Backup
op3(){
    read -rp "Diretório para backup: " DIRETORIO_ORIGEM
    if [ ! -d "$DIRETORIO_ORIGEM" ]; then
      echo "Erro: Diretório não existe."
      return
    fi
    DADO_TEMPO=$(date +"%Y%m%d_%H%M%S")
    NOME_BASE=$(basename "$DIRETORIO_ORIGEM")
    DIRETORIO_PAI=$(dirname "$DIRETORIO_ORIGEM")
    DIRETORIO_BACKUP="$DIRETORIO_PAI/backup_${NOME_BASE}_$DADO_TEMPO"
    cp -r "$DIRETORIO_ORIGEM" "$DIRETORIO_BACKUP"
    echo "Backup realizado em '$DIRETORIO_BACKUP'"
}

# Opção 4: Criar usuário
op4(){
    if [[ $EUID -ne 0 ]]; then
       echo "Este script deve ser executado como root."
       return
    fi
    read -rp "Novo usuário: " NOVO_USUARIO
    if id "$NOVO_USUARIO" &>/dev/null; then
        echo "Usuário já existe."
        return
    fi
    read -rp "Nome completo: " NOME_COMPLETO
    read -rp "Número da sala: " SALA
    read -rp "Telefone trabalho: " TELEFONE_TRABALHO
    read -rp "Telefone residencial: " TELEFONE_RESIDENCIAL
    read -rp "Outras informações: " OUTROS
    GECOS="${NOME_COMPLETO},${SALA},${TELEFONE_TRABALHO},${TELEFONE_RESIDENCIAL},${OUTROS}"
    adduser --gecos "$GECOS" "$NOVO_USUARIO"
    usermod -aG sudo "$NOVO_USUARIO"
    echo "Usuário criado com sucesso."
}
