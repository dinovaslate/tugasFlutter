import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';
import 'footer_info.dart';

const String baseUrl = 'http://10.0.2.2:8000';

void main() {
  runApp(
    Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _brandPrimary = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandPrimary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(
              bodyColor: const Color(0xFF0B3D02),
              displayColor: const Color(0xFF0B3D02),
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _brandPrimary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    final request = context.read<CookieRequest>();
    final response = await request.login('$baseUrl/auth/login/', {
      'username': _usernameController.text.trim(),
      'password': _passwordController.text,
    });

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    if (request.loggedIn) {
      final username =
          (response['username'] as String?) ?? _usernameController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login berhasil!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: username)),
      );
    } else {
      final message = response['message'] ?? 'Login gagal.';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message.toString()),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Football Shop Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        color: Color(0xFF1B5E20),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Masuk ke Football Shop',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Login'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _isLoading ? null : _goToRegister,
                        child: const Text('Belum punya akun? Daftar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password1': _passwordController.text,
          'password2': _confirmPasswordController.text,
        }),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>? ?? {};

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        final message = decoded['message']?.toString() ?? 'Registrasi gagal.';
        final errors = decoded['errors'];
        final buffer = StringBuffer(message);
        if (errors is Map<String, dynamic>) {
          for (final entry in errors.entries) {
            final value = entry.value;
            if (value is List) {
              buffer.writeln('\n- ${value.join(", ")}');
            } else {
              buffer.writeln('\n- $value');
            }
          }
        }
        setState(() {
          _errorMessage = buffer.toString();
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $error';
      });
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
      appBar: AppBar(title: const Text('Registrasi Akun')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 8) {
                            return 'Minimal 8 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleRegister,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Daftar'),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum OwnerFilterMode { all, mine, custom }

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});

  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;
  OwnerFilterMode _ownerFilter = OwnerFilterMode.all;
  String? _customOwnerFilter;
  final GlobalKey _filterAnchorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final request = context.read<CookieRequest>();
    final response = await request.get(_buildProductsEndpoint());
    final rawList = response as List<dynamic>;
    final products =
        rawList
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return products;
  }

  Future<void> _refreshProducts() async {
    final refreshed = _fetchProducts();
    setState(() {
      _productsFuture = refreshed;
    });
    await refreshed;
  }

  String _buildProductsEndpoint() {
    String base = '$baseUrl/products/json/';
    if (_ownerFilter == OwnerFilterMode.mine) {
      return '$base?owner=me';
    }
    if (_ownerFilter == OwnerFilterMode.custom &&
        (_customOwnerFilter?.isNotEmpty ?? false)) {
      final owner = Uri.encodeComponent(_customOwnerFilter!.trim());
      return '$base?owner=$owner';
    }
    return base;
  }

  String _filterDescription() {
    switch (_ownerFilter) {
      case OwnerFilterMode.all:
        return 'Semua produk';
      case OwnerFilterMode.mine:
        return 'Produk milik ${widget.username}';
      case OwnerFilterMode.custom:
        return _customOwnerFilter == null
            ? 'Semua produk'
            : 'Produk milik $_customOwnerFilter';
    }
  }

  Future<void> _changeFilter(OwnerFilterMode mode) async {
    if (mode == OwnerFilterMode.custom) {
      final username = await _promptUsernameFilter();
      if (username == null) return;
      setState(() {
        _ownerFilter = OwnerFilterMode.custom;
        _customOwnerFilter = username;
      });
    } else {
      setState(() {
        _ownerFilter = mode;
        _customOwnerFilter = null;
      });
    }
    await _refreshProducts();
  }

  Future<void> _showFilterMenu() async {
    final overlay = Overlay.of(context);
    final RenderBox? overlayBox =
        overlay.context.findRenderObject() as RenderBox?;
    final RenderBox? box =
        _filterAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (overlayBox == null || box == null) return;
    final Offset position = box.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );

    final OwnerFilterMode? selected = await showMenu<OwnerFilterMode>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + box.size.height,
        position.dx + box.size.width,
        position.dy,
      ),
      items: const [
        PopupMenuItem(value: OwnerFilterMode.all, child: Text('Semua produk')),
        PopupMenuItem(value: OwnerFilterMode.mine, child: Text('Produk saya')),
        PopupMenuItem(
          value: OwnerFilterMode.custom,
          child: Text('Filter berdasarkan username...'),
        ),
      ],
    );

    if (selected != null) {
      _changeFilter(selected);
    }
  }

  Future<String?> _promptUsernameFilter() async {
    final controller = TextEditingController(text: _customOwnerFilter ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter berdasarkan username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
    if (result == null) return null;
    final trimmed = result.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _handleLogout() async {
    final request = context.read<CookieRequest>();
    await request.logout('$baseUrl/auth/logout/');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _openProductForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormPage(username: widget.username),
      ),
    ).then((_) => _refreshProducts());
  }

  Future<void> _openDetail(Product product) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItemDetailPage(product: product, username: widget.username),
      ),
    );
    if (changed == true && mounted) {
      _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
            tooltip: 'Muat ulang',
          ),
          PopupMenuButton<OwnerFilterMode>(
            icon: const Icon(Icons.filter_list),
            onSelected: (mode) => _changeFilter(mode),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: OwnerFilterMode.all,
                child: Text('Semua produk'),
              ),
              PopupMenuItem(
                value: OwnerFilterMode.mine,
                child: Text('Produk saya'),
              ),
              PopupMenuItem(
                value: OwnerFilterMode.custom,
                child: Text('Filter berdasarkan username...'),
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(
        username: widget.username,
        onTapHome: () {},
        onTapAddProduct: _openProductForm,
        onTapLogout: _handleLogout,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat data: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _refreshProducts,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba lagi'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              String emptyMessage;
              switch (_ownerFilter) {
                case OwnerFilterMode.mine:
                  emptyMessage = 'Belum ada produk milik ${widget.username}.';
                  break;
                case OwnerFilterMode.custom:
                  emptyMessage = _customOwnerFilter == null
                      ? 'Tidak ada produk yang cocok.'
                      : 'Tidak ada produk milik $_customOwnerFilter.';
                  break;
                case OwnerFilterMode.all:
                  emptyMessage = 'Belum ada produk yang dapat ditampilkan.';
                  break;
              }
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 72,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          emptyMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (_ownerFilter != OwnerFilterMode.all) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => _changeFilter(OwnerFilterMode.all),
                            child: const Text('Tampilkan semua produk'),
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _openProductForm,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Tambah Produk'),
                        ),
                        const SizedBox(height: 32),
                        const FooterInfo(),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
              itemCount: products.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        size: 72,
                        color: Color(0xFF1B5E20),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Hai, ${widget.username}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola produk unggulanmu dan lihat detailnya secara langsung.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        key: _filterAnchorKey,
                        borderRadius: BorderRadius.circular(12),
                        onTap: _showFilterMenu,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.filter_alt_outlined, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _filterDescription(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                              if (_ownerFilter == OwnerFilterMode.custom &&
                                  (_customOwnerFilter?.isNotEmpty ?? false))
                                TextButton(
                                  onPressed: () =>
                                      _changeFilter(OwnerFilterMode.all),
                                  child: const Text('Hapus filter'),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                if (index == products.length + 1) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 32, bottom: 48),
                    child: FooterInfo(),
                  );
                }
                final product = products[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ItemCard(
                    product: product,
                    onTap: () => _openDetail(product),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openProductForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = product.isFeatured
        ? const Color(0xFFFFB300)
        : const Color(0xFF1B5E20);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _proxiedThumbnail(product.thumbnail),
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, __) {
                    debugPrint(
                      'Failed to load image ${product.thumbnail}: $error',
                    );
                    return Container(
                      width: 84,
                      height: 84,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (product.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Featured',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.formattedPrice,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF0D47A1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.categoryLabel,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({
    super.key,
    required this.product,
    required this.username,
  });

  final Product product;
  final String username;

  Future<void> _handleEdit(BuildContext context) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductFormPage(username: username, product: product),
      ),
    );
    if (updated == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus produk?'),
        content: const Text(
          'Tindakan ini tidak dapat dibatalkan. Apakah kamu yakin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    if (!context.mounted) return;
    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        '$baseUrl/products/${product.id}/delete/',
        jsonEncode({}),
      );
      if (!context.mounted) return;
      if (response['status'] == 'success') {
        Navigator.pop(context, true);
      } else {
        final message =
            response['message'] ?? 'Gagal menghapus produk dari server.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message.toString())));
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat menghapus: $error')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner = product.ownerUsername == username;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                _proxiedThumbnail(product.thumbnail),
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, error, __) {
                  debugPrint(
                    'Failed to load image ${product.thumbnail}: $error',
                  );
                  return Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 48),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.formattedPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF0D47A1),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _DetailChip(
                  icon: Icons.person_outline,
                  label: 'Pemilik: ${product.ownerUsername}',
                ),
                _DetailChip(
                  icon: Icons.category_outlined,
                  label: product.categoryLabel,
                ),
                _DetailChip(
                  icon: Icons.star_outline,
                  label: product.isFeatured
                      ? 'Produk unggulan'
                      : 'Produk biasa',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Deskripsi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Dibuat: ${product.createdAt}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              'Diperbarui: ${product.updatedAt}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            if (isOwner) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleEdit(context),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleDelete(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali ke daftar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 16), label: Text(label));
  }
}

String _proxiedThumbnail(String originalUrl) {
  final encoded = Uri.encodeComponent(originalUrl);
  return '$baseUrl/utils/image-proxy/?url=$encoded';
}

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key, required this.username, this.product});

  final String username;
  final Product? product;

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
    'Boots',
    'Ball',
    'Accessories',
    'Other',
  ];

  String _selectedCategory = 'Jersey';
  bool _isFeatured = false;
  double _price = 0;
  String _name = '';
  String _description = '';
  String _thumbnail = '';
  bool _isSubmitting = false;

  late final bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    if (_isEditing) {
      final product = widget.product!;
      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _descriptionController.text = product.description;
      _thumbnailController.text = product.thumbnail;
      _selectedCategory = _slugToCategoryLabel(product.category);
      _isFeatured = product.isFeatured;
      _name = product.name;
      _price = product.price;
      _description = product.description;
      _thumbnail = product.thumbnail;
    }
  }

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

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    final request = context.read<CookieRequest>();
    final payload = {
      'name': _name,
      'price': _price,
      'description': _description,
      'category': _categoryToSlug(_selectedCategory),
      'thumbnail': _thumbnail,
      'is_featured': _isFeatured,
    };

    final endpoint = _isEditing
        ? '$baseUrl/products/${widget.product!.id}/update/'
        : '$baseUrl/products/create/';

    try {
      final response = await request.postJson(endpoint, jsonEncode(payload));

      if (!mounted) return;

      if (response['status'] == 'success') {
        if (_isEditing) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Produk berhasil diperbarui.')),
            );
          Navigator.pop(context, true);
        } else {
          await showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Produk tersimpan ke server!'),
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
                    child: const Text('Tambah Lagi'),
                  ),
                ],
              );
            },
          );
          _resetForm();
        }
      } else {
        final message =
            response['message'] ?? 'Gagal menyimpan produk ke server.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message.toString())));
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _goBackHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(username: widget.username),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final request = context.read<CookieRequest>();
    await request.logout('$baseUrl/auth/logout/');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Produk' : 'Tambah Produk Baru'),
        centerTitle: true,
      ),
      drawer: AppDrawer(
        username: widget.username,
        onTapHome: _goBackHome,
        onTapAddProduct: () {},
        onTapLogout: _handleLogout,
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
                onSaved: (value) =>
                    _selectedCategory = value ?? _categories.first,
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
                  if (uri == null ||
                      !(uri.isScheme('http') || uri.isScheme('https'))) {
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
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _slugToCategoryLabel(String slug) {
    switch (slug) {
      case 'jersey':
        return 'Jersey';
      case 'boots':
        return 'Boots';
      case 'ball':
        return 'Ball';
      case 'accessory':
        return 'Accessories';
      default:
        return 'Other';
    }
  }

  String _categoryToSlug(String label) {
    switch (label) {
      case 'Jersey':
        return 'jersey';
      case 'Boots':
        return 'boots';
      case 'Ball':
        return 'ball';
      case 'Accessories':
        return 'accessory';
      default:
        return 'other';
    }
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.username,
    required this.onTapHome,
    required this.onTapAddProduct,
    required this.onTapLogout,
  });

  final String username;
  final VoidCallback onTapHome;
  final VoidCallback onTapAddProduct;
  final VoidCallback onTapLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: const Text('Football Shop User'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF1B5E20)),
            ),
            decoration: const BoxDecoration(color: Color(0xFF1B5E20)),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pop(context);
              onTapHome();
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Tambah Produk'),
            onTap: () {
              Navigator.pop(context);
              onTapAddProduct();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              onTapLogout();
            },
          ),
        ],
      ),
    );
  }
}
