.PHONY: all clean publish test

all:
	@sudo docker build -t qeda-ci .

clean:
	@rm -rvf qeda
	@sudo docker rmi -f qeda-ci || true
	@sudo docker rm -f qeda-ci || true

test:
	@sudo docker build -t qeda-ci .
	@./test.sh
