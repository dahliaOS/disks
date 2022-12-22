import 'dart:io';

import 'package:disks/provider/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenit_ui/zenit_ui.dart';

void main() async {
  if (!kIsWeb && !Platform.isAndroid) {
    await ZenitWindow.initialize(
      options: const WindowOptions(
        size: Size(800, 600),
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
        minimumSize: Size(240, 120),
        title: "Disks",
      ),
    );
  }
  runApp(const ProviderScope(child: DisksApp()));
}

class DisksApp extends ConsumerStatefulWidget {
  const DisksApp({super.key});

  @override
  ConsumerState<DisksApp> createState() => _DisksAppState();
}

class _DisksAppState extends ConsumerState<DisksApp> {
  @override
  void initState() {
    final model = ref.read(disksModelProvider);
    model.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final diskList = ref.watch(diskListProvider);
    final virtualWindowFrameBuilder = ZenitWindowFrameInit();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeEngine.zenitDefaultLightTheme,
      darkTheme: ThemeEngine.zenitDefaultDarkTheme,
      builder: (context, child) {
        return SafeArea(child: virtualWindowFrameBuilder(context, child));
      },
      home: Scaffold(
        appBar: const ZenitWindowTitlebar(),
        body: diskList.when(
          data: (data) {
            return ZenitNavigationLayout(
              length: data.length,
              destinationBuilder: (context, index, selected) => ZenitLayoutTile(
                title: data[index].titleBuilder(context),
                leading: data[index].iconBuilder(context, selected),
              ),
              pageBuilder: (context, index) => data[index].pageBuilder(context),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => throw Exception(error),
        ),
      ),
    );
  }
}
