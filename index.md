---
layout: default
---

## Getting Started

**{{ site.description }}**

1. Make sure [Helm](https://helm.sh) is [installed](https://helm.sh/docs/intro/install/).

2. You can then add this repository to your local helm configuration as follows:
```console
$ helm repo add {{ site.repo_name }} {{ site.url }}
$ helm repo update
```

3. You can then see the charts in our repository in the [Charts](#charts) section of this page or using the following command:
```console
$ helm search repo authelia
```

## Charts

{% for helm_chart in site.data.index.entries %}
{% assign title = helm_chart[0] | capitalize %}
{% assign all_charts = helm_chart[1] | sort: 'created' | reverse %}
{% assign latest_chart = all_charts[0] %}

<h3>
  {% if latest_chart.icon %}
  <img src="{{ latest_chart.icon }}" style="height:1.2em;vertical-align: text-top;" />
  {% endif %}
  {{ title }}
</h3>

[Home]({{ latest_chart.home }}) \| [Chart Source]({{ latest_chart.sources[0] }}) \| [Application Source]({{ latest_chart.sources[1] }})

{{ latest_chart.description }}

```console
$ helm install {{ site.repo_name }}/{{ latest_chart.name }} --name myrelease --version {{ latest_chart.version }}
```

| Chart Version | App Version | API Version | Date |
|---------------|-------------|-------------|------|
{% for chart in all_charts -%}
{% unless chart.version contains "-" -%}
| [{{ chart.version }}]({{ chart.urls[0] }}) | {{ chart.appVersion }} | {{ chart.apiVersion }} | {{ chart.created | date_to_rfc822 }} |
{% endunless -%}
{% endfor -%}
{% endfor %}