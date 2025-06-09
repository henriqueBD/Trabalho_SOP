#!/bin/bash

source op.sh

while true; do
    clear
    
    cat tabela1.txt
    
    # obter o ano
    ano=$(date +%Y)
    # obter o num do mes
    mes=$(date +%m)
    
    # determinar o semestre com base no mes
    if [ "$mes" -le 6 ]; then
      semestre=1
    else
      semestre=2
    fi
    
    echo "# ${semestre}º Semestre de ${ano}                                      #"
    
    cat tabela2.txt

    #obtem a data e hora formatados
    DATA=$(date +"%d/%m/%Y")
    HORA=$(date +"%H:%M:%S")
    
    echo "Rio de Janeiro \"$DATA\". \"$HORA\"."

    # exibe o menu de escolhas
    cat menu_escolhas.txt
    read -rp "Escolha uma opção: " OPCAO

    # executa comando com base na escolha do usuario
    case "$OPCAO" in
        1) op1 ;;
        2) op2 ;;
        3) op3 ;;
        4) op4 ;;
        5) echo "Saindo..."; break ;;
        *) echo "Opção inválida. Tente novamente." ;;
    esac

    echo "Aperte qualquer tecla para voltar para o menu"
    # espera o usuario apertar uma tecla para continuar
    read -n 1 -s
done
