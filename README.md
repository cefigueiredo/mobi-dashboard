##Procedimentos de Instalação: 
### Dependências externas:
Para a instalação do projeto, é preciso que seja instalado no sistema operacional os seguintes softwares:

* libmysqlclient-dev
* Ruby v2.x (testado em 2.0.0, 2.1.1 e 2.1.2)
* [Bundler](http://bundler.io/) (só precisa rodar o comando `gem install bundler`)

###Banco de dados
O sistema esta preparado para funcionar com o banco de dados MySQL Server. Mas para isso é preciso informar os dados de conexão com o banco de dados.   
Para isso, é preciso preencher as configuraçoes na sessão de `production` do arquivo `config\database.yml`. O que deve ser configurado é bem auto-explicativo:

```
#!Yaml

production:
  adapter: mysql2  #nao deve ser alterado
  database: dashboard_newrelic  #nome da base utilizada, escolha livre
  host: localhost 
  pool: 10
  username: root 
  password: vagrant
```


###Variáveis de ambiente:
Também é preciso configurar a variável de ambiente que dirá que o software deve ser carregado em modo de produção.     

* RACK_ENV=production


### Instalação do projeto
Após instaladas as dependencias externas, é preciso dar o comando `bundle install` na raiz do projeto, para as dependências internas serem instaladas...
A aplicação já irá instalar o servidor de aplicação Thin e suas dependencias.

Após a instalação do projeto, é preciso rodar a rake responsável por gerar as tabelas necessárias pela aplicação.

O comando para gerar as tabelas na base de dados é `rake db:migrate`

### Execução da aplicação
Feita a configuração do banco com sucesso, para executar a aplicação é preciso rodar o comando:

`bundle exec thin start -R config.ru -e $RACK_ENV`

Obs.: Por padrão, a porta em que a aplicação roda é a 3000, mas se quiser alterar é só adicionar este parametro no comando: `-p $PORT`