import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/material_service.dart';
import '../models/material_model.dart' as material_model;

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final MaterialService _materialService = MaterialService();
  bool _isLoading = true;
  List<material_model.Material> _materials = [];
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() => _isLoading = true);
    try {
      final result = await _materialService.getMaterials(type: _selectedType);
      if (result['success'] && result['data'] != null) {
        setState(() {
          _materials = (result['data'] as List)
              .map((m) => material_model.Material.fromJson(m))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading materials: $e');
    }
    setState(() => _isLoading = false);
  }

  IconData _getMaterialIcon(String type) {
    switch (type) {
      case 'ppt':
        return Icons.slideshow;
      case 'notes':
        return Icons.note;
      case 'pyq':
        return Icons.quiz;
      default:
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Materials'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedType == null,
                    onSelected: (selected) {
                      setState(() => _selectedType = null);
                      _loadMaterials();
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('PPT'),
                    selected: _selectedType == 'ppt',
                    onSelected: (selected) {
                      setState(() => _selectedType = selected ? 'ppt' : null);
                      _loadMaterials();
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Notes'),
                    selected: _selectedType == 'notes',
                    onSelected: (selected) {
                      setState(() => _selectedType = selected ? 'notes' : null);
                      _loadMaterials();
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('PYQ'),
                    selected: _selectedType == 'pyq',
                    onSelected: (selected) {
                      setState(() => _selectedType = selected ? 'pyq' : null);
                      _loadMaterials();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _materials.isEmpty
              ? const Center(child: Text('No materials found'))
              : RefreshIndicator(
                  onRefresh: _loadMaterials,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _materials.length,
                    itemBuilder: (context, index) {
                      final material = _materials[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_getMaterialIcon(material.type), color: AppColors.primary),
                          ),
                          title: Text(material.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(material.type.toUpperCase(), style: const TextStyle(fontSize: 10)),
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(material.subject, style: const TextStyle(color: AppColors.primary)),
                                ],
                              ),
                              if (material.description != null)
                                Text(material.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Download started')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
