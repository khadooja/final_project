import 'package:flutter/material.dart';

abstract class GenericTable<T> extends StatelessWidget {
  final List<String> columnNames;
  final List<T> data;
  final Widget Function(BuildContext, T) buildRow;
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const GenericTable({
    super.key,
    required this.columnNames,
    required this.data,
    required this.buildRow,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // رأس الجدول
        SizedBox(
          height: 50,
          child: _buildTableHeader(),
        ),

        // جسم الجدول مع تحديد ارتفاع ثابت
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: data
                  .map((item) => SizedBox(
                        height: 60,
                        child: buildRow(context, item),
                      ))
                  .toList(),
            ),
          ),
        ),

        // تذييل الجدول (ترقيم الصفحات)
        SizedBox(
          height: 60,
          child: _buildPaginationControls(),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: columnNames
              .map((title) => SizedBox(
                    width: _calculateColumnWidth(title),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  double _calculateColumnWidth(String title) {
    const baseWidth = 120.0;
    final lengthFactor = title.length * 8.0;
    return baseWidth + lengthFactor;
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        Text('صفحة $currentPage من $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
