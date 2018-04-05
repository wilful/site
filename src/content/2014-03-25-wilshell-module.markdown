Title: "Пишем свой модуль для wilshell, краткое HOWTO"
Date: 2014-03-25 11:52:16 +0600
Category: shell
Authors: A. Semenov
Tags: linux, bash, shell, scripts

Блок определений:

    NAME='default'
    AUTHOR='wilful'
    DESCRIPTION='An example of module configuration'
    USAGE='-a  Первый ключ, флаг запуска
    Можно поставить 
        табы или например \n перенос строки
    -b  Второй ключ, значение для запуска'
    MODULE_DEPENDS=( 'lock' )

        NAME - имя модуля, на основании этой переменной строятся внутренние вызовы к модулю
        AUTHOR - Собственно автор модуля
        DESCRIPTION - Описание модуля (выводится при вызове wilshell без параметров)
        USAGE - Список опций модуля, описание работы модуля (выводится при запуске модуля без параметров)
        MODULE\_DEPENDS - если необходимо использовать функции из других модулей


Блок чтения параметров скрипта:

    InitOpts () {
        RUN_FLAG=2#000
        unset OPT_VAL
        while getopts ":am:v" opt; do
            case $opt in
                'a') 
                    RUN_FLAG=$((RUN_FLAG+2#001));
                ;;
                'm') 
                    OPT_VAL=${OPTARG}
                ;;
                'v') 
                    log 3 "[${MODULE}]";
                ;;
                '?'|':'|*) 
                    Usage ${MODULE}
                    exit 1
                ;;
            esac
        done

Имя функции "InitOpts" обязательное и менять его нельзя. Добавляем нужные аргументы в массив параметров getopts (в данном примере ":am:v" означает, что функция будет ожидать ключ "-m" с аргументами и ключи "-v -a" без аргументов)
В следующем блоке запускается обработчик параметров:

    case ${RUN_FLAG} in
        '1')
            LockFun "${MODULE}-[$(basename ${SCRIPT_RUN})]";
            TestFunction ${OPT_VAL}
            UnLockFun "${MODULE}-[$(basename ${SCRIPT_RUN})]";
        ;;
        *)
            Usage ${MODULE}
            exit 1
        ;;
    esac

На этом этапе осуществляется вызов функций и основная часть функционала модуля, в зависимости от ключей и параметров могут вызываться различные условия оператора case.

В последнем блоке можно добавлять любые функции, которые будут необходимы в операторе case:

    TestFunction () {
        : ${1?"Not enough parameters. Usage: $FUNCNAME Parameter"}
        echo ${1:-"This function displays the text"}
    }

Пример модуля можно посмотреть [тут][link01].

[link01]: https://github.com/wilful/root-shell/blob/master/usr/modules/default.module
