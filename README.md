# Desafio DevOps Medcloud

Este repositório contém o código-fonte e a configuração para o desafio de DevOps da Medcloud. A infraestrutura será provisionada na AWS, utilizando Terraform, e o pipeline de CI/CD será automatizado com GitHub Actions.

## 🏗️ Arquitetura

### Backend (Node.js + Express)
- API REST 
- Conexão com banco de dados MySQL (Amazon RDS)
- Containerização com Docker

### Infraestrutura AWS (Terraform)
- **Compute**: Amazon ECS (Elastic Container Service) com Fargate
- **Database**: Amazon RDS MySQL
- **Network**: VPC customizada com subnets em múltiplas AZs
- **Load Balancer**: Application Load Balancer (ALB)
- **Storage**: Amazon S3 para artefatos de deploy
- **Registry**: Amazon ECR para imagens Docker

## 🚀 Pipeline de CI/CD
- GitHub Actions para automação do deploy
- Fluxo automatizado de build e deploy para AWS
- Armazenamento de artefatos no S3
- Integração com ECR para gestão de containers

## 💻 Tecnologias Utilizadas

### Backend
- Node.js
- Express.js
- MySQL2
- Docker

### Infraestrutura
- Terraform
- AWS (ECS, RDS, ECR, S3, VPC, ALB)
- GitHub Actions

## 🔧 Configuração e Deploy

### Pré-requisitos
- Node.js
- Docker
- Terraform
- Conta AWS
- GitHub Account

### Variáveis de Ambiente Necessárias
```env
PORT=80
DB_HOST=endpoint-do-rds
DB_USER=usuario-do-banco
DB_PASSWORD=senha-do-banco
DB_NAME=nome-do-banco
```

### Secrets do GitHub (para CI/CD)
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`


## 🏛️ Estrutura do Projeto
```
├── application/
│   ├── controllers/
│   │   └── petController.js
│   ├── database/
│   │   └── db.js
│   ├── Dockerfile
│   └── index.js
├── infra/
│   └── terraform/
│       ├── ecs.tf
│       ├── rds.tf
│       ├── vpc.tf
│       └── ...
└── .github/
    └── workflows/
        └── deploy.yaml
```

## 🔐 Segurança
- VPC com subnets privadas e públicas
- Security Groups para controle de acesso
- Secrets gerenciados via GitHub Secrets
- RDS em subnet privada

## 📦 Armazenamento de Artefatos
- Imagens Docker no Amazon ECR
- Artefatos de deploy no Amazon S3
- Logs de aplicação no CloudWatch

## 🔄 Processo de Deploy
1. Push para a branch main
2. GitHub Actions inicia o pipeline
3. Build e push da imagem Docker para ECR
4. Upload dos artefatos para S3
5. Deploy no ECS Fargate
6. Validação de saúde da aplicação

## 🌐 Escalabilidade
- ECS Fargate para escala automática de containers
- ALB para distribuição de carga
- RDS com capacidade de escala vertical e horizontal

## 📈 Monitoramento
- Health check via ALB
- Logs do container no CloudWatch
- Métricas de infraestrutura AWS
        
        
