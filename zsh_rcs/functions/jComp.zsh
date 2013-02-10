
# ------------------------------------------------------------------------------
#          FILE:  jComp.plugin.zsh
#   DESCRIPTION:  javac with a diffrent path.
#        AUTHOR:  Filip Pettersson (filip.diloom@gmail.com)
#       VERSION:  1.0.1
# ------------------------------------------------------------------------------


function jComp() {

# local java_mods = ""

if (( $# == 0 )); then
    echo "using on all .java in folder"
    javac "*.java"
    return

elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "Usage: jComp [java modules] [file]"
    echo
    echo "Options:"
    echo "    -h,   This help message."
    echo "modules has to be in the (java-config -l) list" 
    echo
    echo "Report bugs to <tellone.diloom@gmail.com>."
    
    return 0
fi

if [[ "$(java-config -v)" == "" ]]; then
    echo "This script depends on java-config"
    return 1
elif [[ "$1" == "-m" ]]; then
    mvn archetype:generate -DgroupId=com.diloom."$2" -DartifactId=$2 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
elif [[ "$1" == "-d" ]] || [[ "$1" == "--default" ]]; then
    `javac -cp .:$(java-config -p junit-4) *.java`
    if [[ $# == 2 ]]; then
        `javac -c .:$(java-config -p junit-4) "$2"`
        return 0
    fi
fi


while (( $# > 1 )); do
    if [[ ! -f "$1" ]]; then
        java_mods="$java_mods $1"
        shift
        continue
    fi
done

`javac -cp .:$(java-config $java_mods)`

return 1

}
