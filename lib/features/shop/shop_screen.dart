import 'package:cab_app/core/models/product.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:cab_app/shared/widgets/empty.dart';
import 'package:cab_app/shared/widgets/error_view.dart';
import 'package:cab_app/shared/widgets/logo.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:cab_app/shared/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/providers/shop_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/services/sanity_service.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  SHOP SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const CabLogo(size: 26),
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
                      decoration: const BoxDecoration(
                        color: AppColors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            fontFamily: 'Inter', fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, color: t.dividerColor),
        ),
      ),
      body: Consumer<ShopProvider>(
        builder: (context, sp, _) {
          if (sp.loading) {
            return _buildSkeleton();
          }
          if (sp.error != null) {
            return ErrorView(message: sp.error!, onRetry: () => sp.fetchProducts());
          }
          if (sp.products.isEmpty) {
            return const EmptyState(
              icon: Icons.storefront_outlined,
              title: 'Shop coming soon',
              subtitle: 'Our store will be available shortly',
            );
          }

          return RefreshIndicator(
            color: AppColors.yellow,
            onRefresh: () => sp.fetchProducts(),
            child: CustomScrollView(
              slivers: [
                // Category filter
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CategoryFilterDelegate(
                    selectedCategory: sp.selectedCategory,
                    onSelect: sp.setCategory,
                  ),
                ),
                // Product grid
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _ProductGridCard(product: sp.filtered[i]),
                      childCount: sp.filtered.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() => GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, childAspectRatio: 0.72,
      crossAxisSpacing: 10, mainAxisSpacing: 10,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => const SkeletonBox(height: 240, radius: 12),
  );
}

// ─── Category Filter ──────────────────────────────────────────────────────
const _categories = ['all', 'shirts', 'bags', 'accessories'];
const _categoryLabels = {
  'all': 'All',
  'shirts': 'Shirts',
  'bags': 'Bags',
  'accessories': 'Accessories',
};

class _CategoryFilterDelegate extends SliverPersistentHeaderDelegate {
  final String selectedCategory;
  final ValueChanged<String> onSelect;

  _CategoryFilterDelegate({required this.selectedCategory, required this.onSelect});

  @override
  double get minExtent => 54;
  @override
  double get maxExtent => 54;

  @override
  Widget build(BuildContext ctx, double shrinkOffset, bool overlapsContent) {
    final t = Theme.of(ctx);
    return Container(
      color: t.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: _categories.map((cat) {
          final selected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? AppColors.yellow : t.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected ? AppColors.yellow : t.dividerColor,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  _categoryLabels[cat] ?? cat,
                  style: TextStyle(
                    fontFamily: 'Rajdhani', fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.black : t.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryFilterDelegate old) =>
      old.selectedCategory != selectedCategory;
}

// ─── Product Grid Card ────────────────────────────────────────────────────
class _ProductGridCard extends StatelessWidget {
  final ProductModel product;
  const _ProductGridCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final hasImage = product.imageRefs.isNotEmpty;

    return GestureDetector(
      onTap: () => context.push('/shop/${product.id}'),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: t.colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: hasImage
                    ? CabNetworkImage(
                        url: SanityService.imageUrl(product.imageRefs.first, width: 400),
                        fit: BoxFit.cover,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      )
                    : const Center(
                        child: Icon(Icons.storefront, color: AppColors.darkTextSec, size: 40),
                      ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.customizable)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.yellowSurface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.yellow.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'CUSTOM',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.yellow, letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    product.title,
                    style: t.textTheme.titleSmall,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)} TND',
                    style: TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.colorScheme.onSurface,
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
