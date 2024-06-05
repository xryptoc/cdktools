.PHONY: run
run:
	sh scripts/0_common.sh
	sh scripts/1_PrepareKeys.sh
	sh scripts/2_PrepareEnvs.sh
	sh scripts/3_PrepareL1.sh
	sh scripts/4_CreateRollup.sh
	sh scripts/5_CreateCDK.sh

.PHONY: stop
stop:
	docker-compose -f scripts/docker/docker-compose.yml down
	docker-compose -f scripts/data/src/cdk-validium-node/test/docker-compose.yml down	
