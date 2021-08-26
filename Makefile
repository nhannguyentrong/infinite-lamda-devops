backend:
	@cd backend && \
		terraform init && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan
s3:
	@cd infra && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan 
static_deploy:
	@cd infra/deploy/static && \
		terraform plan -out s1.tfplan && \
		terraform apply s1.tfplan 	