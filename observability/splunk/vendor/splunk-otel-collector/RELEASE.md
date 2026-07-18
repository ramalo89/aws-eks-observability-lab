This Splunk OpenTelemetry Collector for Kubernetes release adopts the [Splunk OpenTelemetry Collector v0.156.0](https://github.com/signalfx/splunk-otel-collector/releases/tag/v0.156.0).
### 💡 Enhancements 💡
- `clusterReceiver`: Enable collection of NetworkPolicy and CustomResourceDefinition objects by default via k8s_objects pipeline. ([#4323](https://github.com/signalfx/splunk-otel-collector-chart/pull/4323))
  Added to the default `clusterReceiver.k8sObjects` list in pull mode (6h interval), with the
  required read permissions granted in the chart's ClusterRole.
  Collected only when a destination is enabled: `splunkPlatform.logsEnabled` (Splunk Platform logs)
  and/or `featureGates.sendK8sEventsToSplunkO11y` (Splunk Observability `/v3/event`); sent to each
  that is enabled. To opt out, remove these entries from `clusterReceiver.k8sObjects`.
