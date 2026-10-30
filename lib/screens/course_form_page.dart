
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  const CourseFormPage({
    super.key,
    this.course,
  });

  final Course? course;

  bool get isEditing => course != null;

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;

  late String _status;
  bool _isSubmitting = false;

  static const List<String> _statusOptions = [
    'planned',
    'active',
    'done',
  ];

  @override
  void initState() {
    super.initState();

    final course = widget.course;

    _codeController = TextEditingController(
      text: course?.code ?? '',
    );

    _titleController = TextEditingController(
      text: course?.title ?? '',
    );

    _creditsController = TextEditingController(
      text: course?.credits.toString() ?? '',
    );

    _status = course != null &&
            _statusOptions.contains(course.status)
        ? course.status
        : 'planned';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'done':
        return 'Done';
      default:
        return 'Planned';
    }
  }

  Future<void> _saveCourse() async {
    if (_isSubmitting ||
        !_formKey.currentState!.validate()) {
      return;
    }

    final courseId = widget.course?.id;

    if (widget.isEditing && courseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ID course tidak tersedia sehingga tidak dapat diedit.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final provider = context.read<CourseProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final course = Course(
      id: courseId,
      code: _codeController.text.trim(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );

    try {
      if (widget.isEditing) {
        await provider.updateCourse(courseId!, course);
      } else {
        await provider.createCourse(course);
      }

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Course berhasil diperbarui.'
                : 'Course berhasil ditambahkan.',
          ),
        ),
      );

      navigator.pop(true);
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Gagal memperbarui course: $e'
                : 'Gagal menambahkan course: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Course' : 'Tambah Course',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Made Iwan Darma Saputra',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('NIM: 2415051113'),
              const SizedBox(height: 24),

              TextFormField(
                controller: _codeController,
                readOnly: widget.isEditing,
                decoration: InputDecoration(
                  labelText: 'Kode Course',
                  helperText: widget.isEditing
                      ? 'Kode course tidak dapat diubah.'
                      : null,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kode course wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Course',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul course wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Credits / SKS',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final credits = int.tryParse(
                    value?.trim() ?? '',
                  );

                  if (credits == null) {
                    return 'Credits harus berupa angka bulat.';
                  }

                  if (credits <= 0) {
                    return 'Credits harus lebih dari 0.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(_statusLabel(status)),
                  );
                }).toList(),
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _status = value;
                          });
                        }
                      },
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _saveCourse,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        widget.isEditing
                            ? Icons.save
                            : Icons.add,
                      ),
                label: Text(
                  _isSubmitting
                      ? 'Menyimpan...'
                      : widget.isEditing
                          ? 'Simpan Perubahan'
                          : 'Simpan Course',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
