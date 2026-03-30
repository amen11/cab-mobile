// ═════════════════════════════════════════════════════════════════════════════
//  CART SCREEN
// ═════════════════════════════════════════════════════════════════════════════
import 'package:cab_app/core/providers/cart_provider.dart';
import 'package:cab_app/core/services/sanity_service.dart';
import 'package:cab_app/core/theme/app_theme.dart';
import 'package:cab_app/shared/widgets/empty.dart';
import 'package:cab_app/shared/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Cart', style: t.textTheme.headlineSmall),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add items from the shop',
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _CartItemCard(item: cart.items[i]),
                ),
              ),
              // Order summary + checkout
              Container(
                decoration: BoxDecoration(
                  color: t.colorScheme.surface,
                  border: Border(top: BorderSide(color: t.dividerColor, width: 0.5)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${cart.itemCount} item(s)', style: t.textTheme.bodyMedium),
                        Text(
                          '${cart.total.toStringAsFixed(0)} TND',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: t.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/checkout'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('PROCEED TO CHECKOUT'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cart = context.read<CartProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: t.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.product.imageRefs.isNotEmpty
                  ? CabNetworkImage(
                      url: SanityService.imageUrl(item.product.imageRefs.first, width: 200),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : const Icon(Icons.storefront, color: AppColors.darkTextSec),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.title, style: t.textTheme.titleSmall),
                  if (item.customName != null || item.customNumber != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (item.customName != null) item.customName!,
                        if (item.customNumber != null) '#${item.customNumber}',
                      ].join(' · '),
                      style: TextStyle(
                        fontFamily: 'Inter', fontSize: 11,
                        color: t.colorScheme.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${item.product.price.toStringAsFixed(0)} TND',
                    style: TextStyle(
                      fontFamily: 'Rajdhani', fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: t.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity control
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () => cart.updateQuantity(item.product.id, item.quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.quantity}', style: t.textTheme.titleMedium),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: () => cart.updateQuantity(item.product.id, item.quantity + 1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => cart.removeItem(item.product.id),
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontFamily: 'Inter', fontSize: 11,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: t.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: t.dividerColor, width: 0.5),
        ),
        child: Icon(icon, size: 14, color: t.colorScheme.onSurface),
      ),
    );
  }
}
