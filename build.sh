BASEDIR=$(dirname $0)

ulimit -n 1024
jake clean install $BASEDIR
