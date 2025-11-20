GO=go
HELM_UNITTEST_VERSION ?= v1.0.3
HELM_UNITTEST_REPO ?= https://github.com/helm-unittest/helm-unittest

docs: install-helm-docs
	helm-docs

schema: install-helm-schema
	helm-schema

lint: lint-chart lint-chart-package lint-chart-version lint-docs

lint-chart:
	@ct --config .buildkite/ct.yaml lint

lint-chart-version:
	@ct --config .buildkite/ct.version.yaml lint

lint-chart-package:
	@ct --config .buildkite/ct.yaml list-changed --since HEAD~1 | xargs -n1 cr --config .buildkite/cr.yaml package

lint-docs:
	@(git diff-index --quiet HEAD charts/**/README.md) || (echo "Documentation is outdated, run make docs") && (git diff --color-words charts/**/README.md) && false
	@echo "Documentation up to date"

helm-unittest-install:
	@if ! helm plugin list | tail -n +2 | awk '{print $$1}' | grep -q "^unittest$$"; then \
		echo "Installing helm-unittest plugin $(HELM_UNITTEST_VERSION)"; \
		helm plugin install $(HELM_UNITTEST_REPO) --version $(HELM_UNITTEST_VERSION) --verify=false; \
	else \
		echo "helm-unittest plugin already installed"; \
	fi

test-chart: helm-unittest-install
	@helm unittest charts/authelia

install: install-helm-docs install-helm-schema

install-helm-docs:
	${GO} install github.com/norwoodj/helm-docs/cmd/helm-docs@latest

install-helm-schema:
	${GO} install github.com/dadav/helm-schema/cmd/helm-schema@latest

release: release-package release-upload release-index

release-package:
	@ct --config .buildkite/ct.yaml list-changed --since HEAD~1 | xargs -n1 cr --config .buildkite/cr.yaml package

release-upload:
	@cr --config .buildkite/cr.yaml upload --auto-release

release-index:
	@cr --config .buildkite/cr.yaml index --push