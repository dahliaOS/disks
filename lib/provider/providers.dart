import 'package:disks/provider/udisks_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udisks/udisks.dart';
import 'package:zenit_ui/zenit_ui.dart';

// UDisks provider
final udisksProvider = Provider<UDisksClient>((ref) {
  final client = UDisksClient();

  ref.onDispose(() => client.close());

  return client;
});

// Provider interface for the UDisks client
final disksModelProvider = ChangeNotifierProvider<DisksModel>((ref) {
  final model = DisksModel(ref.read(udisksProvider));

  model.init();

  ref.onDispose(() => model.dispose());

  return model;
});

// Create the list of ZenitLayoutItems based on the Disks
final diskListProvider = FutureProvider<List<ZenitLayoutItem>>((ref) async {
  final controller = ref.read(disksModelProvider);
  while (controller.disks.isEmpty) {
    await Future.delayed(Duration.zero);
  }
  return controller.disks.map((disk) {
    return ZenitLayoutItem(
      titleBuilder: (selected) => Text(disk.model),
      iconBuilder: (context, selected) => const Icon(Icons.sd_storage_rounded),
      pageBuilder: (context) => Center(
        child: Text(disk.size.toString()),
      ),
    );
  }).toList();
});
