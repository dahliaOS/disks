import 'package:udisks/udisks.dart';
import 'package:zenit_ui/zenit_ui.dart';

class DisksModel extends ChangeNotifier {
  final UDisksClient _client;

  DisksModel(this._client);

  void init() async {
    await _client.connect();
    notifyListeners();
  }

  List<UDisksDrive> get disks => _client.drives;
}
