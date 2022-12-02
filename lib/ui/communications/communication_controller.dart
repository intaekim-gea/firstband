import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gea_communications/gea_communications.dart';
import 'package:gea_datasource/gea_datasource.dart';
import 'package:get/get.dart';
import 'package:shqs_util/shqs_util.dart';

abstract class Packet {
  final String packet;
  final DateTime date = DateTime.now();
  Packet(this.packet);

  String get dateString {
    return date.toDateUTCTimeZone();
  }
}

class Sent extends Packet {
  Sent(super.packet);
  @override
  String toString() => '$dateString: Sent <$packet>';
}

class Received extends Packet {
  Received(super.packet);
  @override
  String toString() => '$dateString: Received <$packet>';
}

class CommunicationController extends GetxController {
  final String _tag;

  final CommunicationAdapter _dataSource = GeaDatasource();

  Peripheral? _peripheral;
  final _subscriptions = <StreamSubscription>[];

  final formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();

  CommunicationController(String tag) : _tag = tag;

  final packetLog = <Packet>[].obs;

  @override
  void onInit() {
    super.onInit();
    _dataSource.initialize().then(
      (value) {
        _subscriptions.add(
          _dataSource.deviceList().listen(
            (list) async {
              _peripheral = await _dataSource.connect(list.first);
              if (_peripheral == null) {
                throw UnsupportedError('Failed To Connect: ${list.first}');
              }

              _subscriptions.add(
                _peripheral!.listen(
                  (GeaEvent e) {
                    if (e is GeaDataEvent) {
                      debugPrint('GeaDataEvent: ${e.data}');
                      final bytes = Uint8StringList.fromBytes(e.data);
                      if (e is GeaDataEventSent) {
                        debugPrint('sent: $bytes');
                        packetLog.add(Sent('$bytes'));
                      } else {
                        debugPrint('received: $bytes');
                        packetLog.add(Received('$bytes'));
                      }
                    } else if (e is GeaEventDisconnected) {
                      debugPrint('disconnected');
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
    _dataSource.scan();

    textEditingController.text = 'ff01e401';
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('CommunicationController: onClose');
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    textEditingController.dispose();
  }

  String? validator(String? value) {
    try {
      value = value?.refinedHexStringFromHex;
    } catch (e) {
      return 'This field must be hex digits';
    }

    if (value == null || value.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void sendPacket() {
    if (formKey.currentState?.validate() ?? false) {
      final packet = textEditingController.text.uint8ListFromHex;
      _peripheral?.sendPacket(packet);
    }
  }

  void disconnect() {
    _peripheral?.close();
    Get.back();
  }
}
