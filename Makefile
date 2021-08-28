backend:
	@cd backend && \
		terraform init && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan
s3:
	@cd infra/deploy/s3 && \
		terraform init && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan 

database:
	@cd infra/deploy/database && \
		terraform init && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan 

docker:
	@cd flask_postgres && \
		docker build -t nhannguyen-postgress:latest . && \
		docker run --env-file ./env_file -p 8081:8081 -d nhannguyen-postgress:latest

deploy_static:
	@cd infra/deploy/deploy_static && \
		terraform init && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan 

deploy_docker:
	@cd infra/deploy/deploy_docker && \
		terraform init && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan 	