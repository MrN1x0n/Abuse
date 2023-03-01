#!/bin/bash
file=$(cat proxy.list)
i=1

echo "Enter wallet address where to gather tokens:"
read my_wallet

for line in $file
	do
		nibid keys add temp_wallet$i --keyring-backend test
		wallet_now=$(nibid keys show temp_wallet$i --keyring-backend test -a)
		echo $wallet_now >> ./wallets.txt

		BAL=-1
		while [ $(echo "$BAL < 0" | bc) -eq 1 ]; do
			echo "Asking tokens for temp_wallet${i}"
			curl --proxy $line -X POST -d '{"address": "'"$wallet_now"'", "coins": ["110000000unibi"]}' "https://faucet.itn-1.nibiru.fi/"
			for (( timer=5; timer>0; timer-- ))
                        do
                		        printf "* sleep for %02d sec\r" $timer
		                        sleep 1
                	done
			BAL=$(nibid query bank balances $wallet_now -o json | jq -r '.balances[] | select(.denom=="unibi") | .amount');
			BAL=$(bc <<< "$BAL-100000")
		done

		BAL=$(nibid query bank balances $wallet_now -o json | jq -r '.balances[] | select(.denom=="unibi") | .amount');
		echo -e "\nBalance on testnet_wallet${i}: ${BAL} unibi\n"
		BAL=$(bc <<< "$BAL-100000") #Leave 0.1
		if [ $(echo "$BAL > 100000" | bc) -eq 1 ]
			then
		        	nibid tx bank send temp_wallet$i $my_wallet ${BAL}unibi --fees 6000unibi --keyring-backend test -y
		        else
		                echo -e "Not enough to send!\n"
		fi
		let "i=i+1"
		for (( timer=10; timer>0; timer-- ))
			do
        		printf "* sleep for %02d sec\r" $timer
	                sleep 1
	        done
	done
