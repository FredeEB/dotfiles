function newcpprepo() {
    NAME=$@
    mkdir $NAME
    cd $NAME
    gh repo create --template cpptemplate $NAME
}
