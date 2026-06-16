# Build into bin/ (gitignored) so the binary never collides with the 58com/
# source package at the repo root.
BINARY  := bin/job58
PKG     := ./cmd/job58
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
COMMIT  := $(shell git rev-parse --short HEAD 2>/dev/null || echo none)
DATE    := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
LDFLAGS := -s -w \
	-X github.com/tamnd/58com-cli/cli.Version=$(VERSION) \
	-X github.com/tamnd/58com-cli/cli.Commit=$(COMMIT) \
	-X github.com/tamnd/58com-cli/cli.Date=$(DATE)

.PHONY: build install test vet fmt clean run

build:
	@mkdir -p $(dir $(BINARY))
	CGO_ENABLED=0 go build -trimpath -ldflags "$(LDFLAGS)" -o $(BINARY) $(PKG)

install:
	CGO_ENABLED=0 go install -trimpath -ldflags "$(LDFLAGS)" $(PKG)

test:
	go test ./...

vet:
	go vet ./...

fmt:
	gofmt -w -s .

clean:
	rm -rf bin dist

run: build
	./$(BINARY) $(ARGS)
