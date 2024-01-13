class PaginatedData<T> {
  final List<T> data;
  final int? nextPage;
  final int? totalCount;

  PaginatedData({
    required this.data,
    this.nextPage,
    this.totalCount,
  });
}

class PaginationService<T> {
  Future<PaginatedData<T>> getNextPage({
    required Future<List<T>> Function(int) fetchPage,
    int pageSize = 10,
    int? initialPage,
  }) async {
    final List<T> allData = [];
    int currentPage = initialPage ?? 0;
    int? nextPage;

    while (nextPage == null || currentPage < nextPage) {
      final List<T> pageData = await fetchPage(currentPage);
      allData.addAll(pageData);
      if (pageData.length < pageSize) {
        break;
      }
      nextPage = currentPage + 1;
      currentPage = nextPage;
    }

    return PaginatedData<T>(
      data: allData,
      nextPage: nextPage,
      totalCount: allData.length,
    );
  }
}
