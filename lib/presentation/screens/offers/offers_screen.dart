import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض والخصومات'),
        backgroundColor: isDark ? Colors.grey[900] : colorScheme.primary.withOpacity(0.05),
        foregroundColor: isDark ? Colors.white : colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // عرض الصياغة المجانية 50%
            _buildOfferCard(
              context,
              icon: Icons.local_offer,
              title: 'عرض الصياغة المجانية',
              discount: '50% خصم',
              description: 'احصل على حسم 50% على الصياغة للطلبات أكثر من 40 غرام',
              minimumWeight: '40 غرام',
            ),
            const SizedBox(height: 16),
            
            // عرض الصياغة المجانية الكامل 100%
            _buildOfferCard(
              context,
              icon: Icons.local_offer,
              title: 'عرض الصياغة المجانية الكامل',
              discount: '100% خصم',
              description: 'احصل على صياغة مجانية للطلبات أكثر من 60 غرام',
              minimumWeight: '60 غرام',
            ),
            const SizedBox(height: 16),
            
            // عرض الوزن الثقيل 10%
            _buildOfferCard(
              context,
              icon: Icons.local_offer,
              title: 'عرض الوزن الثقيل',
              discount: '10% خصم',
              description: 'احصل على حسم 10% على السعر للطلبات أكثر من 30 غرام',
              minimumWeight: '30 غرام',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String discount,
    required String description,
    required String minimumWeight,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.25) : Colors.grey.withOpacity(0.12),
            blurRadius: isDark ? 2 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // أيقونة العرض
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // عنوان العرض
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              // نسبة الخصم
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // وصف العرض
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          // الحد الأدنى للوزن
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'الحد الأدنى: $minimumWeight',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
