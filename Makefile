all: entries/*.html index.html

entries/*.html: root/entries/*.md
	./scripts/build_entries.sh

index.html: root/index.md
	./scripts/build_index.sh

clean:
	rm entries/*.html || true
	rm index.html || true