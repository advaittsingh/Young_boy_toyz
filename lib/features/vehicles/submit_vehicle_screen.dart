import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../theme/app_theme.dart';
import '../../../core/models/vehicle.dart';
import '../../../core/utils/validation_utils.dart';

class SubmitVehicleScreen extends StatefulWidget {
  const SubmitVehicleScreen({super.key});

  @override
  State<SubmitVehicleScreen> createState() => _SubmitVehicleScreenState();
}

class _SubmitVehicleScreenState extends State<SubmitVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _locationController = TextEditingController();
  final _modificationController = TextEditingController();
  final _vipNumberController = TextEditingController(); // ✅ Added

  bool _isVipNumber = false; // ✅ Added

  String _selectedMake = '';
  String _selectedModel = '';
  String _selectedCategory = '';
  int _selectedYear = DateTime.now().year;
  List<File> _selectedImages = [];
  List<String> _modifications = [];
  Map<String, String> _specifications = {};
  File? _selectedVideo;

  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _categories = [
    'Vintage / Classics',
    'YBT Premium',
    'GS Collection',
    'Custom Workshop',
    '4x4 Builds',
  ];

  final Map<String, List<String>> _makeModels = {
    'Toyota': ['Supra', 'Land Cruiser', 'Hilux', 'Fortuner', 'Camry', 'Corolla'],
    'Honda': ['Civic', 'Accord', 'CR-V', 'City', 'Jazz'],
    'Nissan': ['GTR', 'Patrol', 'X-Trail', '370Z', 'Skyline'],
    'BMW': ['M3', 'M5', 'X5', 'M4', 'M8'],
    'Mercedes': ['C-Class', 'E-Class', 'G-Class', 'AMG GT', 'S-Class'],
    'Audi': ['RS6', 'Q7', 'R8', 'A4', 'A6'],
    'Porsche': ['911', 'Cayenne', 'Panamera', 'Macan', 'Taycan'],
    'Ferrari': ['F8', 'SF90', 'Roma', '296 GTB', 'Purosangue'],
    'Lamborghini': ['Huracan', 'Aventador', 'Urus', 'Revuelto'],
    'McLaren': ['720S', 'Artura', '765LT', 'Senna'],
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _youtubeController.dispose();
    _locationController.dispose();
    _modificationController.dispose();
    _vipNumberController.dispose(); // ✅ Added
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      
      if (images.isNotEmpty) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

        // Replace the Future.wait call with a synchronous mapping
        final compressedImages = images.map((e) => File(e.path)).toList();

        setState(() {
          _selectedImages.addAll(compressedImages);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick images: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _addModification() {
    if (_modificationController.text.isNotEmpty) {
      setState(() {
        _modifications.add(_modificationController.text);
        _modificationController.clear();
      });
    }
  }

  void _removeModification(int index) {
    setState(() {
      _modifications.removeAt(index);
    });
  }

  void _addSpecification() {
    showDialog(
      context: context,
      builder: (context) {
        final keyController = TextEditingController();
        final valueController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Add Specification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(
                  labelText: 'Specification Name',
                  hintText: 'e.g., Engine, Power, Transmission',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText: 'e.g., 2JZ-GTE, 600 HP, Manual',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (keyController.text.isNotEmpty && valueController.text.isNotEmpty) {
                  setState(() {
                    _specifications[keyController.text] = valueController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeSpecification(String key) {
    setState(() {
      _specifications.remove(key);
    });
  }

  Future<void> _pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideo = File(video.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick video: \\${e.toString()}';
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      setState(() {
        _errorMessage = 'Please add at least one image';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create vehicle object
      final vehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        make: _selectedMake,
        model: _selectedModel,
        year: _selectedYear,
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        location: _locationController.text,
        description: _descriptionController.text,
        modifications: _modifications,
        images: _selectedImages.map((e) => e.path).toList(),
        specifications: _specifications,
        ownerId: '1', // Replace with actual user ID
        ownerName: 'John Doe', // Replace with actual user name
        contactInfo: {
          'phone': _phoneController.text,
          'instagram': _instagramController.text,
          'youtube': _youtubeController.text,
        },
        createdAt: DateTime.now(),
      );

      // TODO: Save vehicle to database
      print('Vehicle created: ${vehicle.toJson()}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehicle submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to submit vehicle: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Vehicle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Basic Information
            Text('Basic Information', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              validator: (value) => value == null || value.isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  // Stack vertically on small screens
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedMake.isEmpty ? null : _selectedMake,
                        decoration: const InputDecoration(labelText: 'Make', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                        items: _makeModels.keys.map((make) => DropdownMenuItem(value: make, child: Text(make))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMake = value!;
                            _selectedModel = '';
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Select make' : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedModel.isEmpty ? null : _selectedModel,
                        decoration: const InputDecoration(labelText: 'Model', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                        items: _selectedMake.isEmpty ? [] : _makeModels[_selectedMake]!.map((model) => DropdownMenuItem(value: model, child: Text(model))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedModel = value!;
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Select model' : null,
                      ),
                    ],
                  );
                } else {
                  // Row for larger screens
                  return Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedMake.isEmpty ? null : _selectedMake,
                          decoration: const InputDecoration(labelText: 'Make', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                          items: _makeModels.keys.map((make) => DropdownMenuItem(value: make, child: Text(make))).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMake = value!;
                              _selectedModel = '';
                            });
                          },
                          validator: (value) => value == null || value.isEmpty ? 'Select make' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedModel.isEmpty ? null : _selectedModel,
                          decoration: const InputDecoration(labelText: 'Model', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                          items: _selectedMake.isEmpty ? [] : _makeModels[_selectedMake]!.map((model) => DropdownMenuItem(value: model, child: Text(model))).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedModel = value!;
                            });
                          },
                          validator: (value) => value == null || value.isEmpty ? 'Select model' : null,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedCategory.isEmpty ? null : _selectedCategory,
                        decoration: const InputDecoration(labelText: 'Category', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                        items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Select category' : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: _selectedYear,
                        decoration: const InputDecoration(labelText: 'Year', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                        items: List.generate(30, (i) => DropdownMenuItem(value: DateTime.now().year - i, child: Text((DateTime.now().year - i).toString()))),
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value!;
                          });
                        },
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory.isEmpty ? null : _selectedCategory,
                          decoration: const InputDecoration(labelText: 'Category', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                          items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          validator: (value) => value == null || value.isEmpty ? 'Select category' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: DropdownButtonFormField<int>(
                          value: _selectedYear,
                          decoration: const InputDecoration(labelText: 'Year', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                          items: List.generate(30, (i) => DropdownMenuItem(value: DateTime.now().year - i, child: Text((DateTime.now().year - i).toString()))),
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price (₹)', prefixText: '₹ ', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'Enter price' : double.tryParse(value) == null ? 'Enter valid price' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              validator: (value) => value == null || value.isEmpty ? 'Enter location' : null,
            ),
             const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Has VIP Number'),
              value: _isVipNumber,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _isVipNumber = value ?? false;
                });
              },
            ),
            if (_isVipNumber)
              TextFormField(
                controller: _vipNumberController,
                decoration: const InputDecoration(labelText: 'VIP Number', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                validator: (value) {
                  if (_isVipNumber && (value == null || value.isEmpty)) {
                    return 'Enter VIP number';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 24),
            // Images
            Text('Images', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.textGrey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImages.isEmpty
                  ? Center(
                      child: TextButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add Images'),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(8),
                      itemCount: _selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _selectedImages.length) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              onPressed: _pickImages,
                              icon: const Icon(Icons.add_photo_alternate),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            // Video
            Text('Video', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library),
              label: Text(_selectedVideo == null ? 'Upload Video' : 'Change Video'),
            ),
            if (_selectedVideo != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Selected: ${_selectedVideo!.path.split('/').last}', style: const TextStyle(color: AppTheme.textGrey)),
              ),
            const SizedBox(height: 24),
            // Modifications
            Text('Modifications', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 400) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: _modificationController,
                        decoration: const InputDecoration(labelText: 'Add Modification', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: _addModification,
                          icon: const Icon(Icons.add_circle),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _modificationController,
                          decoration: const InputDecoration(labelText: 'Add Modification', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
                        ),
                      ),
                      IconButton(
                        onPressed: _addModification,
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _modifications.asMap().entries.map((entry) {
                return Chip(
                  label: Text(entry.value),
                  onDeleted: () => _removeModification(entry.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Specifications
            Text('Specifications', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _specifications.entries.map((entry) {
                return Chip(
                  label: Text('${entry.key}: ${entry.value}'),
                  onDeleted: () => _removeSpecification(entry.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _addSpecification,
              icon: const Icon(Icons.add),
              label: const Text('Add Specification'),
            ),
            const SizedBox(height: 24),
            // Description
            Text('Aftermarket Details', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              maxLines: 5,
              validator: (value) => value == null || value.isEmpty ? 'Enter a description' : null,
            ),
            const SizedBox(height: 24),
            // Contact Information
            Text('Contact Information', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty ? 'Enter phone number' : !ValidationUtils.isValidPhoneNumber(value) ? 'Enter valid Indian phone number' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _youtubeController,
              decoration: const InputDecoration(labelText: 'YouTube Channel (Optional)', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              validator: (value) => value != null && value.isNotEmpty && !ValidationUtils.isValidYoutubeChannel(value) ? 'Enter valid YouTube channel URL' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Submit Vehicle'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
} 