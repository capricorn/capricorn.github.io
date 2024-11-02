all: entries/*.html index.html

entries/*.html: root/entries/*.md
	./scripts/build_entries.sh

index.html: root/index.md pyscripts/pyscripts/insert_goog_analytics.py
	./scripts/build_index.sh | (cd pyscripts && poetry run python -m pyscripts.insert_goog_analytics > ../index.html)

clean:
	rm entries/*.html || true
	rm index.html || true