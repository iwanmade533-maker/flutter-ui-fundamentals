
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_form_page.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedStatus = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreatePage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CourseFormPage(),
      ),
    );
  }

  List<dynamic> _filterCourses(List<dynamic> courses) {
    final keyword = _searchController.text.toLowerCase().trim();

    return courses.where((course) {
      final matchesSearch =
          course.title.toLowerCase().contains(keyword) ||
          course.code.toLowerCase().contains(keyword);

      final matchesStatus = _selectedStatus == 'Semua' ||
          course.status.toLowerCase() ==
              _selectedStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'Semua';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Data Manager'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CourseProvider>().loadCourses();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreatePage(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Course'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.courses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal memuat data course.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.loadCourses(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isCompact = width < 600;
              final isExpanded = width >= 840;

              final crossAxisCount = isCompact
                  ? 1
                  : isExpanded
                      ? 3
                      : 2;

              final filteredCourses =
                  _filterCourses(provider.courses);

              return RefreshIndicator(
                onRefresh: provider.loadCourses,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Informasi mahasiswa.
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        12,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Made Iwan Darma Saputra',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('NIM: 2415051113'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Judul dan jumlah course.
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Daftar Course (${provider.courses.length})',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),

                    // Kolom pencarian.
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        12,
                        16,
                        8,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Cari kode atau nama course...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),

                    // Filter status dan tombol reset.
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedStatus,
                                decoration: InputDecoration(
                                  labelText: 'Filter Status',
                                  prefixIcon:
                                      const Icon(Icons.filter_list),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Semua',
                                    child: Text('Semua Status'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Active',
                                    child: Text('Active'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Planned',
                                    child: Text('Planned'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Done',
                                    child: Text('Done'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedStatus = value;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Reset pencarian dan filter',
                              onPressed: _clearFilters,
                              icon: const Icon(Icons.restart_alt),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),

                    // Kondisi ketika data course kosong.
                    if (provider.courses.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('Belum ada data course.'),
                        ),
                      )

                    // Kondisi ketika pencarian tidak menemukan data.
                    else if (filteredCourses.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Course tidak ditemukan.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Coba kata kunci atau filter lainnya.',
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: _clearFilters,
                                  child: const Text('Reset Filter'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )

                    // ListView untuk compact.
                    else if (isCompact)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          100,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return CourseCard(
                                course: filteredCourses[index],
                              );
                            },
                            childCount: filteredCourses.length,
                          ),
                        ),
                      )

                    // GridView untuk medium dan expanded.
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          100,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return CourseCard(
                                course: filteredCourses[index],
                              );
                            },
                            childCount: filteredCourses.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 8,
                            childAspectRatio:
                                isExpanded ? 1.35 : 1.15,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
