/// One page from a paged *arr history endpoint, with what's needed to page
/// past it.
library;

class HistoryPage<T> {
  const HistoryPage({
    required this.records,
    required this.received,
    this.totalRecords,
  });

  /// The records that parsed. Can be fewer than [received]: a malformed
  /// record is dropped rather than failing the whole page.
  final List<T> records;

  /// How many records the server sent on this page, parseable or not.
  ///
  /// This, not `records.length`, is what says whether the page was full.
  /// Counting only parsed records made one bad record on a full page read
  /// as the last page, and "Load more" disappeared with more history left.
  final int received;

  /// The server's count of all records, when it reports one.
  final int? totalRecords;

  /// Whether another page may exist after this one, which was [page]
  /// (1-based) of [pageSize] records each.
  bool hasMoreAfter({required int page, required int pageSize}) {
    final total = totalRecords;
    if (total != null) return page * pageSize < total;
    return received >= pageSize;
  }

  HistoryPage<R> map<R>(R Function(T record) convert) => HistoryPage(
    records: records.map(convert).toList(),
    received: received,
    totalRecords: totalRecords,
  );
}
