#!/bin/bash

op1() {
    echo "Data e hora atual: $(date +"%A, %d de %B de %Y, %H:%M:%S")"
}

op2() {
    read -rp "Digite o caminho do arquivo que deseja mover: " ARQUIVO_ORIGEM

    # verifica se o arquivo existe
    if [ ! -f "$ARQUIVO_ORIGEM" ]; then
        echo "Erro: O arquivo '$ARQUIVO_ORIGEM' n existe."
        return 1
    fi

    read -rp "Digite o caminho do diretório de destino: " DIRETORIO_DESTINO

    # verifica se o diretório de destino existe
    if [ ! -d "$DIRETORIO_DESTINO" ]; then
        echo "Erro: O diretorio '$DIRETORIO_DESTINO' n existe."
        return 1
    fi

    # move o arquivo
    mv "$ARQUIVO_ORIGEM" "$DIRETORIO_DESTINO"

    # verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Arquivo movido com sucesso para '$DIRETORIO_DESTINO'."
    else
        echo "Erro ao mover o arquivo."
    fi
}

op3(){
    read -rp "Digite o caminho do diretorio que deseja fazer backup: " DIRETORIO_ORIGEM
    
    # verifica se o diretorio de origem foi fornecido
    if [ -z "$DIRETORIO_ORIGEM" ]; then
      echo "Erro: Nenhum diretório de origem fornecido."
      return
    fi
    
    # verifica se o diretorio de origem existe
    if [ ! -d "$DIRETORIO_ORIGEM" ]; then
      echo "Erro: O diretório de origem '$DIRETORIO_ORIGEM' não existe."
      return
    fi
    
    # cria dados de tempo para identificar o backup
    DADO_TEMPO=$(date +"%Y%m%d_%H%M%S")
    
    # obtem o nome base e o diretório pai do diretório de origem
    NOME_BASE=$(basename "$DIRETORIO_ORIGEM")
    DIRETORIO_PAI=$(dirname "$DIRETORIO_ORIGEM")
    
    # define o caminho do diretorio de backup
    DIRETORIO_BACKUP="$DIRETORIO_PAI/backup_${NOME_BASE}_$DADO_TEMPO"
    
    # Copia os arquivos para a pasta de backup
    cp -r "$DIRETORIO_ORIGEM" "$DIRETORIO_BACKUP"
    
    echo "Backup do diretório '$DIRETORIO_ORIGEM' concluído com sucesso em '$DIRETORIO_BACKUP'"
}

op4(){
    # verifica se o script esta como root
    if [[ $EUID -ne 0 ]]; then
       echo "Este script deve ser executado como root."
       return
    fi
    
    read -rp "Digite o novo nome de usuário: " NOVO_USUARIO
    
    # verifica se o usuário já existe
    if id "$NOVO_USUARIO" &>/dev/null; then
        echo "O usuário '$NOVO_USUARIO' já existe."
        return
    fi
    
    # campos de informações (GECOS)
    read -rp "Nome completo: " NOME_COMPLETO
    read -rp "Número da sala: " SALA
    read -rp "Telefone do trabalho: " TELEFONE_TRABALHO
    read -rp "Telefone residencial: " TELEFONE_RESIDENCIAL
    read -rp "Outras informações: " OUTROS
    GECOS="${NOME_COMPLETO},${SALA},${TELEFONE_TRABALHO},${TELEFONE_RESIDENCIAL},${OUTROS}"
    
    adduser --gecos "$GECOS" "$NOVO_USUARIO"
    if [[ $? -ne 0 ]]; then
        echo "Falha ao criar o usuário."
        return
    fi
    
    # definir senha
    read -rp "Deseja definir uma senha para o usuário agora? (s/n): " DEFINIR_SENHA
    if [[ "$DEFINIR_SENHA" =~ ^[Ss]$ ]]; then
        passwd "$NOVO_USUARIO"
    fi
    
    
    usermod -aG sudo "$NOVO_USUARIO"
    
    echo "Usuário '$NOVO_USUARIO' foi criado e adicionado ao grupo 'sudo'."
}
