file=$(cat proxy.txt)
i=30
for line in $file
do
nibid keys add wallet$i
wallet_now=$(nibid keys show wallet$i -a)
sleep 1
echo "Запрашиваем токены"
curl --proxy $line -X POST -d '{"address": "'"$wallet_now"'", "coins": ["110000000unibi","100000000000unusd"]}' "https://faucet.testnet-2.nibiru.fi/"
echo $wallet_now >> $HOME/wallets.txt
sleep 1
nibid tx bank send wallet$i $my_wallet 109990000unibi --chain-id $NIBIRU_CHAIN_ID --fees 6000unibi -y
let "i=i+1"
done
