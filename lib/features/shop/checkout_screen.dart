// ═════════════════════════════════════════════════════════════════════════════
//  CHECKOUT SCREEN
// ═════════════════════════════════════════════════════════════════════════════
import 'package:cab_app/core/providers/cart_provider.dart';
import 'package:cab_app/core/theme/app_theme.dart';
import 'package:cab_app/shared/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _paymentMethod = 'cod';
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final success = await context.read<CartProvider>().submitOrder(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _paymentMethod == 'cod' ? _addressCtrl.text.trim() : null,
      paymentMethod: _paymentMethod,
    );

    setState(() => _loading = false);

    if (success) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.successSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.check, color: AppColors.success, size: 32),
                ),
                const SizedBox(height: 16),
                Text('Order Placed!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'Your order has been received. We will contact you at ${_phoneCtrl.text} to confirm.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.go('/shop');
                  },
                  child: const Text('BACK TO SHOP'),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to place order. Please try again.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Checkout', style: t.textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Contact info ───────────────────────────────────────
              Text('Contact Info', style: t.textTheme.headlineSmall),
              const SizedBox(height: 4),
              const YellowAccentDivider(),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '+216 XX XXX XXX',
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your phone' : null,
              ),

              const SizedBox(height: 28),

              // ── Payment method ─────────────────────────────────────
              Text('Payment Method', style: t.textTheme.headlineSmall),
              const SizedBox(height: 4),
              const YellowAccentDivider(),
              const SizedBox(height: 16),

              _PaymentOption(
                label: 'Cash on Delivery',
                subtitle: 'Pay when your order arrives',
                icon: Icons.payments_outlined,
                value: 'cod',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const SizedBox(height: 8),
              _PaymentOption(
                label: 'Store Pickup',
                subtitle: 'Pick up at our store',
                icon: Icons.store_outlined,
                value: 'pickup',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),

              // ── Delivery address (only for cod) ────────────────────
              if (_paymentMethod == 'cod') ...[
                const SizedBox(height: 20),
                Text('Delivery Address', style: t.textTheme.headlineSmall),
                const SizedBox(height: 4),
                const YellowAccentDivider(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: 'Street, City',
                  ),
                  maxLines: 2,
                  validator: (v) => _paymentMethod == 'cod' && (v == null || v.trim().isEmpty)
                      ? 'Please enter your delivery address' : null,
                ),
              ],

              const SizedBox(height: 28),

              // ── Order summary ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: t.dividerColor, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary', style: t.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    ...cart.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.title} × ${item.quantity}',
                              style: t.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${(item.product.price * item.quantity).toStringAsFixed(0)} TND',
                            style: t.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    )),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: t.textTheme.titleMedium),
                        Text(
                          '${cart.total.toStringAsFixed(0)} TND',
                          style: TextStyle(
                            fontFamily: 'Rajdhani', fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: t.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: _loading ? null : () => _submitOrder(context),
                icon: _loading
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.black,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline, size: 18),
                label: Text(_loading ? 'PLACING ORDER...' : 'PLACE ORDER'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label, subtitle, value, groupValue;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.label, required this.subtitle,
    required this.icon, required this.value,
    required this.groupValue, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final selected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.yellowSurface : t.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.yellow : t.dividerColor,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: selected ? AppColors.yellow : t.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20,
                  color: selected ? AppColors.black : t.colorScheme.onSurface),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: t.textTheme.titleMedium),
                  Text(subtitle, style: t.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? AppColors.yellow : t.colorScheme.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}