import 'package:flutter/material.dart';
import 'package:warcraft_flutter_components/warcraft_flutter_components.dart';

/// Showcases [WarcraftPagination]; stateful so tapping a page actually
/// updates the displayed current page.
class PaginationSection extends StatefulWidget {
  const PaginationSection({super.key});

  @override
  State<PaginationSection> createState() => _PaginationSectionState();
}

class _PaginationSectionState extends State<PaginationSection> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WarcraftPagination(
          currentPage: _currentPage,
          pageCount: 20,
          onPageChanged: (page) => setState(() => _currentPage = page),
        ),
        const SizedBox(height: 8),
        Text(
          'Current page: $_currentPage',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
