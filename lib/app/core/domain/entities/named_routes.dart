enum NamedRoutes {
  splash('/'),
  config('/config-ip-server'),
  login('/login'),
  home('/home'),
  stock('/stock');

  final String route;
  const NamedRoutes(this.route);
}
