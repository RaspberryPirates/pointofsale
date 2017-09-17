#!/bin/bash

PRODUCT_JSONS=(
	'{"id": null, "name": "Diet Coke - 20oz", "price": 1.75, "imageUrl": "https://imgur.com/lLfyHzi.jpg"}'
	'{"id": null, "name": "Coca Cola - 20oz", "price": 1.75, "imageUrl": "https://imgur.com/pYd2PuX.jpg"}'
	'{"id": null, "name": "Diet Pepsi - 20oz", "price": 1.69, "imageUrl": "https://imgur.com/SHsXdns.jpg"}'
	'{"id": null, "name": "Pepsi - 20oz", "price": 1.69, "imageUrl": "https://imgur.com/bsfXytI.jpg"}'
)

for PRODUCT in "${PRODUCT_JSONS[@]}"; do
	curl -i -X POST -H 'Content-Type:application/json' -d "$PRODUCT" http://localhost:8080/product/
done