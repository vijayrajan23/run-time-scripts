#!/usr/bin/env bash


# Dependencies

# sonar server and project
# commands: curl and wget

function print_usage() {
echo "\
Usage: sonar-cli [OPTIONS]
Starts a sonar-cli with the based on the supplied options.
    --platform  Mandatory:* Pass the platform.
    --host      Mandatory:* Pass the host name
    --key       Mandatory:* Pass the project key
    --login     Mandatory:* Pass the project login
    --source    Mandatory:* Pass the project source path
"
}


optspec=":hv-:"
while getopts "$optspec" optchar; do

    case "${optchar}" in
        -)
            case "${OPTARG}" in
                platform=*)
                    PLATFORM=${OPTARG##*=}
                    ;;
                host=*)
                    SONAR_HOST=${OPTARG##*=}
                    ;;
                key=*)
                    PROJECT_KEY=${OPTARG##*=}
                    ;;
                login=*)
                    PROJECT_LOGIN=${OPTARG##*=}
                    ;;
                source=*)
                    SOURCE=${OPTARG##*=}
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

# sonar cli installation
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
unzip sonar-scanner-cli-4.2.0.1873-linux.zip && rm -rf sonar-scanner-cli-4.2.0.1873-linux.zip
mv sonar-scanner-4.2.0.1873-linux sonar-scanner
PATH=$PATH:sonar-scanner/bin

if [ "$PLATFORM" = "node"  ] || [ "$PLATFORM" = "python" ] || [ "$PLATFORM" = "java" ]; then
    echo "code scan platform is: $PLATFORM" 
    sonar-scanner -Dsonar.projectKey=$PROJECT_KEY -Dsonar.sources=$SOURCE  -Dsonar.host.url=$SONAR_HOST  -Dsonar.login=$PROJECT_LOGIN
fi


# usage: 
# bash sonar-cli.sh  --platform=node --host=http://10.0.0.0 --key=dddddd --login=admin --source=.
