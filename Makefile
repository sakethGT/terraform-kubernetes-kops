.PHONY: init plan apply destroy fmt validate clean

init:
	terraform init

plan:
	terraform plan -out=tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy

fmt:
	terraform fmt -recursive

validate:
	terraform validate

clean:
	rm -f tfplan
	rm -rf .terraform/

lint: fmt validate
	@echo "Linting complete."
