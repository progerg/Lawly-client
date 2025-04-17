class AppConfig {
  final String url;

  final String apiSecretKey;

  final String? proxyUrl;

  AppConfig({
    required this.url,
    this.proxyUrl,
  }) : apiSecretKey = '';

  AppConfig copyWith({
    String? url,
    String? proxyUrl,
  }) =>
      AppConfig(
        url: url ?? this.url,
        proxyUrl: proxyUrl ?? this.proxyUrl,
      );
}
