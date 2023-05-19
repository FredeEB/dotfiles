function newcpprepo() {
    NAME=$1; shift
    gh repo create --template fredeeb/cpptemplate $NAME
}
