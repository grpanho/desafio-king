# Desafio KingHost - Analista de Infraestrutura de Hosting Linux

## O que é?

Este projeto faz parte do processo seletivo para o cargo de Analista de Infraestrutura de Hosting Linux da KingHost.

Este desafio foi projetado a fim de medir seu nível de conhecimento com conceitos e tecnologias de mercado focados em IaC(Infra as code), gestão de configuração, containerização e desenvolvimento de pipelines visando a garantia de entrega de um produto. Além disto, avaliaremos padrões adotados bem como a suas capacidades de propor soluções para as demandas apresentades, sempre com o foco de manter os ambientes resilientes e padronizados.


## O desafio

Você, como Analista de Infraestrutura, deverá entregar de forma automatizada a seguinte infraestrutura:

* A infraestrutura deverá ser provisionada em um cloud provider utilizando uma ferramenta de gerenciamento de infraestrutura como código(utilize uma conta gratuita);
* Deverá ser realizado o deploy da ferramenta GitLab(https://about.gitlab.com/) em um docker container utilizando um gestor de configuração de sua preferência;
* No GitLab, desenvolva uma pipeline que execute todo o código desenvolvido, ou seja, provisione uma instância no cloud provider escolhido e faça o deploy do GitLab no novo ambiente disponibilizado;
* **Extra** Adicione um stage a sua pipeline para testes e validação que você julgue necessário para o código desenvolvido de provisionamento e deploy da ferramenta a fim de garantir o funcionamento.

## Requisitos

Para realização deste desafio, deverão ser observados os seguintes requisitos:

* O provedor de cloud escolhido deve ser AWS, GCP ou Microsoft Azure;
* Todo o gerenciamento da infraestrutura deve ser feito através de ferramentas escolhidas, evite processos manuais;

As configurações devem, sempre, prezar pelas boas práticas de segurança, com principal atenção aos seguintes pontos:

* O acesso aos servidores deverá ser possível apenas utilizando chave SSH;
* O repositório não deverá contar com nenhum arquivo que possua dados sensíveis **(caráter eliminatório)**;

Documentação é essencial! Então, use e abuse de arquivos README. :)

## Palavras-chave

Para ajudá-lo em sua jornada, abaixo segue algumas palavras-chave para lhe auxiliar em buscas por onde começar.

* Terraform
* Ansible
* Gitlab
* Docker
* Infra as Code
* Configuration Management
* Continuous Integration
* Continuous Deployment

Você tem alguma dúvida? Você pode enviar um e-mail para XXXX@kinghost.com.br a qualquer momento, que iremos o mais breve possível retorná-lo. ;)

## Entregáveis

Ao final do desafio, você deverá realizar um "pull request" neste repositório, o qual deverá conter o seguinte conteúdo:

* Todo e qualquer arquivo necessário para que possamos reproduzir a infra criada em nossas contas nos players supracitados, e;
* Arquivo README.md, contendo:
* Instruções de como executar a infraestrutura entregue;
* Ferramentas utilizadas, e o por que estas foram escolhidas para a realização do desafio, e;
* Decisões adotadas durante o planejamento e execução do desafio, justificando-as.

**IMPORTANTE: Mesmo que você não consiga concluir o desafio por completo, envie o que você conseguiu fazer!** Iremos avaliar todo e qualquer desenvolvimento que você nos apresentar! O mais importante deste desafio é, que ao final dele, você adquira novos conhecimentos ou aprimore os que você já possui. ;)

Após, envie e-mail para o e-mail XXXXX@kinghost.com.br, com cópia para XXXXXX@kinghost.com.br e XXXXX@kinghost.com.br, com o assunto **"Desafio Prático Infraestrutura Linux"**, sinalizando a entrega do desafio para avaliação.

## Prazo para conclusão

Está informado no e-mail enviado junto com o endereço deste desafio.

## O que será avaliado?

* Raciocínio
* Maneira como você está entregando este desafio
* Capacidade de tomada de decisões técnicas
* Complexidade
* Documentação

**Boa sorte!**
