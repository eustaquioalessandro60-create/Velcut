// Serviços mock usados pelo scaffold. Substitua por integrações reais.

class MockApi {
  Future<List<String>> fetchFeed({int page = 0, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(limit, (i) => 'Post #${page * limit + i + 1}');
  }
}
