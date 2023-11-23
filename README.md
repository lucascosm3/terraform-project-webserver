# README.md

## Visão Geral
Bem-vindo ao `terraform-project-webserver`! Este projeto automatiza a criação de uma infraestrutura robusta para um servidor web usando Terraform. Ele provisiona e gerencia de forma eficiente os recursos necessários na nuvem, garantindo uma configuração de servidor web escalável e segura.

## Estrutura do Projeto
- **Bucket S3**: Utilizado para armazenar arquivos `tfstate` remotamente, garantindo a gestão do estado e colaboração em equipe.
- **DynamoDB Table**: Implementa mecanismo de bloqueio para prevenir conflitos de estado durante operações simultâneas da equipe.
- **VPC**: Estabelece um ambiente de nuvem seguro e isolado para o servidor web.
- **Internet Gateway**: Fornece uma conexão entre o VPC e a internet.
- **Custom Route Table**: Gerencia o roteamento do tráfego de rede dentro do VPC.
- **Subnet**: Segrega a rede dentro do VPC para segurança e gerenciamento aprimorados.
- **Associating Subnet with Route Table**: Conecta a sub-rede à tabela de rotas para gerenciamento eficaz do tráfego de rede.
- **Security Group**: Configura regras de firewall para permitir tráfego nas portas 22 (SSH), 80 (HTTP) e 443 (HTTPS).
- **Network Interface**: Cria uma interface de rede com um IP na sub-rede criada para conectividade de rede.
- **Assigning an Elastic IP to the Network Interface**: Atribui um IP público estático à interface de rede para acesso confiável.
- **Ubuntu Server**: Automatiza a implantação de um servidor Ubuntu e instala/habilita o Apache2 usando scripts de user_data.
- **Outputs**: Fornece informações essenciais sobre o servidor web, como endereços IP e nomes de domínio.

## Pré-requisitos
- Terraform instalado em sua máquina.
- Entendimento básico de Terraform, serviços AWS e infraestrutura de rede.

## Uso
1. Clone o repositório para a sua máquina local.
2. Navegue até o diretório do projeto.
3. Execute `terraform init` para inicializar um diretório de trabalho contendo arquivos de configuração do Terraform.
4. Execute `terraform plan` para visualizar o plano de execução e verificar os recursos que serão criados/modificados.
5. Execute `terraform apply` para aplicar as alterações propostas e configurar a infraestrutura.

## Contribuindo
Contribuições para aprimorar o projeto são bem-vindas. Por favor, siga as seguintes diretrizes:
- Faça um fork do repositório e crie uma nova branch para sua funcionalidade ou correção de bug.
- Certifique-se de que seu código adere ao estilo existente para consistência.
- Atualize o README.md com detalhes das alterações, incluindo novas variáveis de ambiente, portas expostas, locais úteis de arquivos e parâmetros de contêiner.
- Envie um pull request com uma descrição clara das mudanças e quaisquer números de issues relevantes.

## Licença
Este projeto está licenciado sob a [Licença MIT](LICENSE.md) - veja o arquivo LICENSE.md para detalhes.

---

Feliz Terraform! 🚀🌐
