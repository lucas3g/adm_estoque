enum AppEndpoints {
  license('/licenca'),
  login('/login'),
  ccustos('/ccustos'),
  product('/produtos'),
  stock('/conferencia_estoque'),
  imageProduct('https://cdn-cosmos.bluesoft.com.br/products');

  final String path;

  const AppEndpoints(this.path);
}
