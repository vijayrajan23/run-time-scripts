#!/usr/bin/env bash

optspec=":hv-:"
while getopts "$optspec" optchar; do

    case "${optchar}" in
        -)
            case "${OPTARG}" in
                URL=*)
                    SONAR_URL=${OPTARG##*=}
                    ;;                     
                *)
                    echo "Unknown option --${OPTARG}" >&2
                    exit 1
                    ;;
            esac;;
        h)
            print_usage
            exit
            ;;
        v)
            echo "Parsing option: '-${optchar}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done

if ["$SONAR_URL" != ""] 
then
    ./gradlew sonarqube -Dsonar.host.url=$URL
else
    echo "Pass the valid params"        
fi

# Example
# bash sonarqube.sh --URL=http://localhost
