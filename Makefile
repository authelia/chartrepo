GO=go

docs: install-helm-docs
	helm-docs

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

install-helm-docs:
	${GO} install github.com/norwoodj/helm-docs/cmd/helm-docs@latest

release: release-package release-upload release-index

release-package:
	@ct --config .buildkite/ct.yaml list-changed --since HEAD~1 | xargs -n1 cr --config .buildkite/cr.yaml package

release-upload:
	@cr --config .buildkite/cr.yaml upload --auto-release

release-index:
	@cr --config .buildkite/cr.yaml index --push