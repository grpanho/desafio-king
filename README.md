# Desafio King - Analista de Infraestrutura de Hosting Linux

## Executando

### Requisitos:

- Terraform instalado: https://learn.hashicorp.com/tutorials/terraform/install-cli
- Ansible instalado: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-specific-operating-systems 
- Módulos do ansible: ansible.posix, community.general e community.docker
- Chave SSH criada em ~/.ssh/id_rsa.pub ### Especificamente com este nome ###
- Um novo projeto no GCP para criação da estrutura
- Arquivo credentials.json inserido na raiz do projeto, obtido através de uma conta de serviço do GCP: https://cloud.google.com/docs/authentication/getting-started

### Iniciando:

Os módulos do ansible necessários podem ser instalados através do seguintes comandos:

ansible-galaxy collection install [ansible.posix](https://docs.ansible.com/ansible/latest/collections/ansible/posix/mount_module.html)

ansible-galaxy collection install [community.general](https://docs.ansible.com/ansible/latest/collections/community/general/filesystem_module.html)

ansible-galaxy collection install [community.docker](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_module.html)

Altere no arquivo main.tf na linha "ssh-keys = "gabriel_panho:${file("~/.ssh/id_rsa.pub")}" onde diz "gabriel_panho" e no arquivo .gitlab-ci.yml a variável GCP_USER para seu nome de usuário do GCP, ele será utilizado para o acesso via chave SSH nas máquinas.

No diretório do arquivo main.tf, execute sequencialmente:
`terraform init` para iniciar o ambiente do terraform e `terraform apply --auto-approve` para criar a infra que hospedará o gitlab.

Ao final destes comandos, será exibido o IP da máquina instanciada, ele também será inserido no arquivo .ansible.host, utilizado posteriormente.

Feito isto, aguarde entre 3 e 5 minutos para a infra ser construída e execute o comando `ansible-playbook -u $GCP_USER -i .ansible-host docker-gitlab.yml` substituindo $GCP_USER pelo seu nome de usuário do GCP.
Após a execução do mesmo, será exibida a senha inicial do usuário root no gitlab. Dentro de aproximadamente 5 minutos, o container do gitlab estará up e acessível através do IP com a senha obtida.

### Importando o projeto

Estando logado no gitlab, copie a URL do [repositório](https://github.com/grpanho/desafio-king.git), selecione a opção *New Project* na página inicial, depois *Import Project* e *Repo by URL*. Insira a URL do repositório e prossiga com a importação.

### Adicionando um runner

Após ter importado o repositório, acesse-o através do gitlab e na lateral esquerda clique em *Settings* -> CI/CD -> *Runners*  copie a URL exibida e o token. Feito isto, execute o comando a seguir em sua máquina, no diretório do repositório, substituindo novamente seu nome de usuário: 
`ansible-playbook -u $GCP_USER -i .ansible-host docker-gitlab-runner.yml`

Ao executá-lo, será solicitado que insira a URL do gitlab, seu token e o nome do *runner* (livre).

### Executando a pipeline

Estando com o respositório e o *runner* devidamente configurados no gitlab, basta clonar o repositório novamente para sua máquina (através da URL do gitlab, onde via http será solicitada a senha do usuário root) e realizar um push qualquer na branch **main** ou **dev-gcp**.

### Verificando a pipeline

Após o push ser realizado, basta acessar o menu CI/CD -> *Pipelines* na lateral esquerda para verificar se a execução ocorreu normalmente.

## Ferramentas utilizadas

Optei por utilizar o Terraform em conjunto com o Ansible. O Terraform foi escolhido devido a maior facilidade de uso da linguagem declarativa, visto que não tenho grande experiência com IaC. Já o Ansible foi escolhido devido a grande quantidade de módulos prontos para uso e por breves experiências prévias com ele.

## Decisões adotadas

Inicialmente optei pelo uso da AWS, desenvolvi parte do projeto nela como pode ser visto nesta outra branch: https://github.com/grpanho/desafio-king/tree/dev
Contudo, o *free tier* da AWS não oferecia recursos suficientes para o projeto, então migrei para o GCP. Na AWS havia sido criada uma rede e subrede para máquinas relacionadas ao Gitlab, contudo por questão de tempo e conhecimento do GCP nem todas as configurações foram replicadas.

Outro ponto foi a utilização de um disco a parte para os volumes do gitlab e gitlab runner, desta forma a VM pode ser destruida via terraform mas os dados das aplicações não são perdidos, bastando iniciar uma nova VM e executar novamente o playbook do ansible.

Optei pelo uso do Centos 7 como sistema operacional por já estar familiarizado com o mesmo, facilitando algumas configurações.