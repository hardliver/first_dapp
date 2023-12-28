import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class LifeMeaningModel extends ChangeNotifier {
  static const String contractName = "LifeMeaning";
  static const String ip = "192.168.68.105";
  static const String port = "7545";
  final String _rpcURL = "http://$ip:$port";
  final String _wsURL = "ws://$ip:$port";
  final String _privateKey =
      "0x270a4958ab34479b2d2e6c844c2e737c040475869eadfcec44ede535cca9e28c";

  late Web3Client _client;
  late Credentials _credentials;
  late DeployedContract _contract;

  late ContractFunction _getLifeMeaning;
  late ContractFunction _setLifeMeaning;

  BigInt? lifeMeaning;
  bool loading = true;

  LifeMeaningModel(context) {
    initialize(context);
  }

  initialize(context) async {
    _client = Web3Client(
      _rpcURL,
      Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsURL).cast<String>();
      },
    );

    final abiStringFile = await DefaultAssetBundle.of(context)
        .loadString("build/contracts/$contractName.json");
    final abiJson = jsonDecode(abiStringFile);
    final abi = jsonEncode(abiJson["abi"]);

    final contractAddress =
        EthereumAddress.fromHex(abiJson["networks"]["5777"]["address"]);
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _contract = DeployedContract(
        ContractAbi.fromJson(abi, contractName), contractAddress);

    _getLifeMeaning = _contract.function("get");
    _setLifeMeaning = _contract.function("set");
    getMeaning();
  }

  Future<void> getMeaning() async {
    final result = await _client
        .call(contract: _contract, function: _getLifeMeaning, params: []);
    lifeMeaning = result[0];
    loading = false;
    notifyListeners();
  }

  Future<void> setMeaning(BigInt value) async {
    loading = true;
    notifyListeners();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _setLifeMeaning,
        parameters: [value],
      ),
      chainId: 1337,
    );

    getMeaning();
  }
}
