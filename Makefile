GO                 ?= go
PACKAGE_PATH       ?= .cr-release-packages
OCI_REGISTRY       ?= ghcr.io
OCI_REGISTRY_OWNER ?= authelia
OCI_REGISTRY_REPO  ?= chartrepo

OCI_TARGET = oci://$(OCI_REGISTRY)/$(OCI_REGISTRY_OWNER)/$(OCI_REGISTRY_REPO)

.PHONY: docs

docs: install-helm-docs
	helm-docs

.PHONY: schema

schema: install-helm-schema
	helm-schema

.PHONY: lint lint-chart lint-chart-package lint-chart-version lint-docs lint-schema

lint: lint-chart lint-chart-package lint-chart-version lint-docs lint-schema

lint-chart:
	@ct --config .buildkite/ct.yaml lint

lint-chart-version:
	@ct --config .buildkite/ct.version.yaml lint

lint-chart-package: release-package

lint-docs: docs
	@files=$$(git ls-files 'charts/*/README.md'); \
	if [ -n "$$files" ] && ! git diff-index --quiet HEAD -- $$files; then \
		echo "Documentation is outdated, run 'make docs'"; \
		git diff --color-words -- $$files; \
		exit 1; \
	fi
	@echo "Documentation is up to date"

lint-schema: schema
	@files=$$(git ls-files 'charts/*/values.schema.json'); \
	if [ -n "$$files" ] && ! git diff-index --quiet HEAD -- $$files; then \
		echo "Values JSON schema is outdated, run 'make schema'"; \
		git diff --color-words -- $$files; \
		exit 1; \
	fi
	@echo "Values JSON schema is up to date"

.PHONY: install install-helm-docs install-helm-schema

install: install-helm-docs install-helm-schema

install-helm-docs:
	$(GO) install github.com/norwoodj/helm-docs/cmd/helm-docs@latest

install-helm-schema:
	$(GO) install github.com/dadav/helm-schema/cmd/helm-schema@latest

.PHONY: release release-package release-upload release-index release-oci release-oci-login release-oci-push

release: release-package release-upload release-index release-oci

release-package:
	@ct --config .buildkite/ct.yaml list-changed --since HEAD~1 | xargs -n1 cr --config .buildkite/cr.yaml package

release-upload:
	@cr --config .buildkite/cr.yaml upload --auto-release

release-index:
	@cr --config .buildkite/cr.yaml index --push

release-oci: release-oci-login release-oci-push

release-oci-login:
	@echo "${CR_TOKEN}" | helm registry login ${OCI_REGISTRY} --username "${CR_USERNAME}" --password-stdin

release-oci-push:
	@pkgs=$$(find $(PACKAGE_PATH) -maxdepth 1 -type f -name '*.tgz'); \
	if [ -z "$$pkgs" ]; then \
		echo "No chart packages found in $(PACKAGE_PATH)"; \
		exit 1; \
	fi; \
	for pkg in $$pkgs; do \
		echo "Pushing $$pkg to $(OCI_TARGET)"; \
		helm push "$$pkg" $(OCI_TARGET); \
	done