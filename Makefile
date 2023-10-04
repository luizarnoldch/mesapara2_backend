TEMPLATE_FILE := templates/main.yml
STACK_NAME := smaily

init:
	go mod init github.com/luizarnoldch/mesapara2_backend
update:
	go mod tidy
start:
	go run main.go
mock:
	mockery --all --output ./tests/mocks/
build:
	./scripts/build.sh
test:
	go test ./tests/...
f_test:
	./scripts/func_test.sh
deploy:
	sam deploy --template-file $(TEMPLATE_FILE) --stack-name $(STACK_NAME) --capabilities CAPABILITY_NAMED_IAM
destroy:
	aws cloudformation delete-stack --stack-name $(STACK_NAME)
e2e:
	make destroy
	sleep 5
	make test
	make build
	make deploy
	sleep 3
	make f_test