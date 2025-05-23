import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class EmptyRouteParser extends RouteInformationParser<UrlState> {
  const EmptyRouteParser();

  @override
  Future<UrlState> parseRouteInformation(RouteInformation routeInformation) {
    final urlState = UrlState(Uri.parse('/'), const []);
    return Future<UrlState>.value(urlState);
  }

  @override
  RouteInformation restoreRouteInformation(UrlState configuration) {
    return AutoRouteInformation(
      uri: configuration.url.isEmpty ? Uri(scheme: '/') : configuration.uri,
      replace: false,
    );
  }
}
