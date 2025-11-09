import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _brandPrimary = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandPrimary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF0B3D02),
          displayColor: const Color(0xFF0B3D02),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _brandPrimary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Shop Dashboard'),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        onTapHome: () {
          Navigator.pop(context);
        },
        onTapAddProduct: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductFormPage(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sports_soccer,
              size: 96,
              color: Color(0xFF1B5E20),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Football Shop',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Discover, manage, and create your football merchandise with ease.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sports_soccer),
                label: const Text('All Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showSnackBar(
                  context,
                  'Kamu telah menekan tombol All Products',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.inventory_2),
                label: const Text('My Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showSnackBar(
                  context,
                  'Kamu telah menekan tombol My Products',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle),
                label: const Text('Tambah Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductFormPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  final List<String> _categories = [
    'Jersey',
    'Shoes',
    'Accessories',
    'Training Gear',
  ];

  String _selectedCategory = 'Jersey';
  bool _isFeatured = false;
  double _price = 0;
  String _name = '';
  String _description = '';
  String _thumbnail = '';

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    setState(() {
      _selectedCategory = _categories.first;
      _isFeatured = false;
    });
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Produk berhasil disimpan!'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text('Nama: $_name'),
                  Text('Harga: Rp${_price.toStringAsFixed(2)}'),
                  Text('Deskripsi: $_description'),
                  Text('Kategori: $_selectedCategory'),
                  Text('Thumbnail: $_thumbnail'),
                  Text('Produk unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      ).then((_) => _resetForm());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk Baru'),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        onTapHome: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        onTapAddProduct: () {
          Navigator.pop(context);
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  hintText: 'Masukkan nama produk',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama produk minimal 3 karakter';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  hintText: 'Masukkan harga produk',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga produk wajib diisi';
                  }
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null) {
                    return 'Harga harus berupa angka';
                  }
                  if (parsed <= 0) {
                    return 'Harga harus lebih dari 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!.replaceAll(',', '.'));
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Tuliskan deskripsi singkat produk',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi produk wajib diisi';
                  }
                  if (value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!.trim(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedCategory,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                onSaved: (value) => _selectedCategory = value ?? _categories.first,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(
                  labelText: 'URL Thumbnail',
                  hintText: 'https://contoh.com/gambar-produk.jpg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL thumbnail wajib diisi';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
                    return 'URL harus diawali http atau https';
                  }
                  return null;
                },
                onSaved: (value) => _thumbnail = value!.trim(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Tandai sebagai produk unggulan'),
                value: _isFeatured,
                onChanged: (value) {
                  setState(() {
                    _isFeatured = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.onTapHome,
    required this.onTapAddProduct,
  });

  final VoidCallback onTapHome;
  final VoidCallback onTapAddProduct;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF1B5E20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Football Shop',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Kelola dan tambah produk favoritmu!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: onTapHome,
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Tambah Produk'),
            onTap: onTapAddProduct,
          ),
        ],
      ),
    );
  }
}
