# Abuse script 4 CURL

Нода должна быть запущена в --keyring-backend test, чтобы не запрашивала пароли. 
В противном случае, могут быть ошибки, за которые я отвечать не могу.
У кого --keyring-backend os, можете просто дописать к командам кошелька и транзакциям --keyring-backend test. 
Тоже будет работать, но за стабильность не отвечаю.

Формат прокси файла(proxy.txt)
http://login:pass@ip:port/ 
или 
http://ip:port/ если прокси без пароля.

Также необходимо задать 
my_wallet=<ВАШ_АДРЕС_НИБИРУ_КОШЕЛЬКА>
 
