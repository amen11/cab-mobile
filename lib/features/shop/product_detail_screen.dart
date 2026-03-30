// ═════════════════════════════════════════════════════════════════════════════
//  PRODUCT DETAIL SCREEN
// ═════════════════════════════════════════════════════════════════════════════
import 'package:cab_app/core/providers/cart_provider.dart';
import 'package:cab_app/core/providers/shop_provider.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:cab_app/core/theme/app_theme.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:cab_app/shared/widgets/yellow_tag.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;
  final _customNameCtrl = TextEditingController();
  final _customNumberCtrl = TextEditingController();

  @override
  void dispose() {
    _customNameCtrl.dispose();
    _customNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final product = context.read<ShopProvider>().products
        .where((p) => p.id == widget.productId)
        .firstOrNull;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const ErrorView(message: 'Product not found'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => context.push('/cart'),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                      child: Center(child: Text('${cart.itemCount}',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.black))),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image viewer ─────────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 320, width: double.infinity,
                  color: t.colorScheme.surfaceVariant,
                  child: product.imageRefs.isNotEmpty
                      ? CabNetworkImage(
                          url: SanityService.imageUrl(
                              product.imageRefs[_imageIndex], width: 800),
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Icon(Icons.storefront, size: 60, color: AppColors.darkTextSec)),
                ),
                if (product.imageRefs.length > 1)
                  Positioned(
                    bottom: 12, left: 0, right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: product.imageRefs.asMap().entries.map((e) {
                        return GestureDetector(
                          onTap: () => setState(() => _imageIndex = e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: e.key == _imageIndex ? 20 : 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: e.key == _imageIndex
                                  ? AppColors.yellow
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Name + price ───────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(product.title, style: t.textTheme.headlineMedium),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${product.price.toStringAsFixed(0)} TND',
                        style: TextStyle(
                          fontFamily: 'Rajdhani', fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: t.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      YellowTag(text: product.category.toUpperCase()),
                      if (product.customizable) ...[
                        const SizedBox(width: 8),
                        YellowTag(text: 'CUSTOMIZABLE'),
                      ],
                    ],
                  ),

                  if (product.description != null) ...[
                    const SizedBox(height: 20),
                    Text('Description', style: t.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(product.description!, style: t.textTheme.bodyLarge),
                  ],

                  // ── Customization ──────────────────────────────────
                  if (product.customizable) ...[
                    const SizedBox(height: 24),
                    Text('Customization', style: t.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    const YellowAccentDivider(),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _customNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Player Name (optional)',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customNumberCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Number (optional)',
                        prefixIcon: Icon(Icons.tag),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ── Add to cart ────────────────────────────────────
                  ElevatedButton.icon(
                    onPressed: product.inStock ? () {
                      context.read<CartProvider>().addItem(
                        product,
                        customName: _customNameCtrl.text.isNotEmpty
                            ? _customNameCtrl.text : null,
                        customNumber: _customNumberCtrl.text.isNotEmpty
                            ? _customNumberCtrl.text : null,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart'),
                          backgroundColor: AppColors.darkCard,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: AppColors.yellow,
                            onPressed: () => context.push('/cart'),
                          ),
                        ),
                      );
                    } : null,
                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                    label: Text(product.inStock ? 'ADD TO CART' : 'OUT OF STOCK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: product.inStock ? AppColors.yellow : AppColors.darkTextSec,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
