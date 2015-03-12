alias cdPyAdvanced="cd ~/Dropbox/OSL/Cursos/2014/PythonAvanzado/contenido/curso-python-avanzado"
alias cdScratch="cd ~/Dropbox/OSL/Cursos/Scratch"

alias autoSuspend="sudo bash ~/auto_suspend.sh"
alias sensors="while(true) ; do clear; sensors; sleep 0.5; done"
alias yed="java -jar /opt/yEd/yed.jar &"


alias sslDQE='echo DQE_`openssl rand -hex 4` | xclip -selection clipboard'
alias sslTDQE='echo -n TDQE_`openssl rand -hex 4` | xclip -selection clipboard'

alias HerculesMount='echo <password> | sshfs seravb@Hercules:/ ~/HerculesMount -o workaround=rename -o password_stdin'
alias HM='HerculesMount'
alias HerculesUmount='fusermount -u ~/HerculesMount'
alias HUM='HerculesUmount'
alias Hercules='sshpass -p <password> ssh seravb@Hercules'
