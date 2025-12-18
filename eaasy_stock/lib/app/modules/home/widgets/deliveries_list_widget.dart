import 'package:eaasy_stock/app/modules/home/widgets/delivery_details_dialog.dart';
import 'package:eaasy_stock/app/theme/app_theme.dart';
import 'package:eaasy_stock/app/utils/date_parser.dart';
import 'package:eaasy_stock/app/utils/delivery_processor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../controllers/home_controller.dart';

class DeliveriesListWidget extends GetView<HomeController> {
  const DeliveriesListWidget({super.key});

  String _formatDateHeader(String dateKey) {
    try {
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateKey);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));

      if (date == today) {
        return "Hoje";
      } else if (date == yesterday) {
        return "Ontem";
      } else {
        return DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(date);
      }
    } catch (e) {
      return dateKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.displayedDeliveries.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.package(PhosphorIconsStyle.duotone),
                  size: 64,
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                ),
                SizedBox(height: 16),
                Text(
                  'No deliveries found.'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final groupedDeliveries =
          DeliveryProcessor.groupByDate(controller.displayedDeliveries);
      final totalGroups = groupedDeliveries.length;
      final hasMoreItems = controller.isLoadingMore.value;

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index >= totalGroups) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: List.generate(
                    3,
                    (i) => Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE5E7EB),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width: 100,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE5E7EB),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            final dateKey = groupedDeliveries.keys.elementAt(index);
            final deliveriesForDate = groupedDeliveries[dateKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PhosphorIcons.calendarBlank(
                                  PhosphorIconsStyle.bold),
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              _formatDateHeader(dateKey),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${deliveriesForDate.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...deliveriesForDate.map((delivery) {
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          PhosphorIcons.package(PhosphorIconsStyle.duotone),
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        delivery.trackingCode,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIcons.clock(),
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formatTime(delivery.registerDate),
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        PhosphorIcons.caretRight(),
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => DeliveryDetailsDialog(
                            delivery: delivery,
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
                SizedBox(height: 8),
              ],
            );
          },
          childCount: totalGroups + (hasMoreItems ? 1 : 0),
        ),
      );
    });
  }

  String _formatTime(String registerDate) {
    return DateParser.formatTime(registerDate);
  }
}
