import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/kora_colors.dart';
import '../domain/mortgage.dart';
import '../../../core/brand/brand.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mortgage products')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          for (final product in MortgageProduct.values) ...[
            _ProductCard(product: product),
            const SizedBox(height: 12),
          ],
          if (Brand.current.showDemoHints)
            Text(
              'Rates shown are indicative for this concept demo.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.kora.muted,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final MortgageProduct product;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kora.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kora.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: kora.accent,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  product.rateLabel,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: kora.onAccent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (Brand.current.showDemoHints) Text(product.blurb),
          const SizedBox(height: 12),
          _Fact(
            icon: Icons.payments_outlined,
            text:
                'Up to ${product.maxAmount.format(showKobo: false)} over up to '
                '${product.maxYears} years',
          ),
          const SizedBox(height: 4),
          _Fact(icon: Icons.verified_user_outlined, text: product.eligibility),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                context.push(Routes.mortgageCalculator, extra: product),
            icon: const Icon(Icons.calculate_outlined),
            label: const Text('Calculate repayments'),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: context.kora.secondary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, style: TextStyle(color: context.kora.muted)),
      ),
    ],
  );
}
