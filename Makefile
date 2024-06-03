.PHONY: keys
keys:
	sh scripts/0_common.sh
	sh scripts/1_PrepareKeys.sh
	sh scripts/2_PrepareEnvs.sh
	sh scripts/3_PrepareL1.sh
	sh scripts/4_CreateRollup.sh
	sh scripts/5_CreateCDK.sh