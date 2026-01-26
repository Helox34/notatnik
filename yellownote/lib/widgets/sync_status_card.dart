import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../providers/data_provider.dart';
import '../services/firebase_sync_service.dart';

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final syncService = dataProvider.syncService;
    
    final status = syncService.status;
    final lastSync = syncService.lastSyncTime;

    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case SyncStatus.synced:
        statusText = 'Zsynchronizowano';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case SyncStatus.syncing:
        statusText = 'Synchronizacja...';
        statusColor = AppColors.yellow;
        statusIcon = Icons.sync;
        break;
      case SyncStatus.error:
        statusText = 'Błąd synchronizacji';
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case SyncStatus.offline:
        statusText = 'Tryb offline';
        statusColor = Colors.orange;
        statusIcon = Icons.cloud_off;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, size: 20, color: statusColor),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (lastSync != null)
            Text(
              'Ostatnia synhr: ${DateFormat('dd.MM.yyyy HH:mm').format(lastSync)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          if (status == SyncStatus.error && syncService.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                syncService.errorMessage!,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.redAccent,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: status == SyncStatus.syncing
                ? null
                : () async {
                    await dataProvider.syncAll();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Synchronizacja zakończona'),
                          backgroundColor: AppColors.yellow,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.darkNavy,
              disabledBackgroundColor: Colors.grey,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              status == SyncStatus.syncing ? 'Synchronizuję...' : 'Synchronizuj teraz',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
