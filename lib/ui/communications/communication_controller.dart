import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gea_comms_ios/gea_comms_ios.dart';
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

  final CommunicationAdapter dataSource = GeaDatasource();

  Peripheral? _peripheral;
  final isConnected = false.obs;
  final _subscriptions = <StreamSubscription>[];

  final formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();

  CommunicationController(String tag) : _tag = tag;

  final packetLog = <Packet>[].obs;

  @override
  void onInit() {
    super.onInit();
    dataSource.initialize().then((_) => tryToConnect());
    textEditingController.text = 'ff01e401';
  }

  void tryToConnect() {
    _peripheral?.close();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    _subscriptions.add(
      dataSource.deviceList().listen(
        (list) async {
          final peripheral = list.firstOrNullWhere((element) {
            if (element is BtClassicPeripheral) {
              return element.acc.macAddress == _tag;
            }
            return false;
          });
          if (peripheral == null) return;
          if (_peripheral != null) return; // Already Connected

          _peripheral = await dataSource.connect(peripheral);
          if (_peripheral == null) {
            throw UnsupportedError('Failed To Connect: ${list.first}');
          }

          debugPrint('Connected: $_tag');
          isConnected.value = true;
          _subscriptions.add(
            _peripheral!.listen(
              (GeaEvent e) {
                if (e is GeaDataEvent) {
                  // debugPrint('GeaDataEvent: ${e.data}');
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
                  _peripheral = null;
                  isConnected.value = false;
                }
              },
            ),
          );
        },
      ),
    );
    dataSource.scan();
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

  void playMusic(String erd) {
    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString('${(id++).hex1byteString}${erd}0101'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }

  void stopMusic(String erd) {
    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString('${(id++).hex1byteString}${erd}0100'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }

  static int id = 0;
  void playNote(int midi) {
    if (midi < 0) {
      return;
    }

    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString(
          '${(id++).hex1byteString}f40002${midi.hex2byteString}'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }

  void playDrainPump() {
    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString(
          '${(id++).hex1byteString}f402 04 04b0 04b0'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }

  void stopDrainPump() {
    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString(
          '${(id++).hex1byteString} f402 04 0000 0000'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }

  void playLidLock() {
    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString(
          '${(id++).hex1byteString}f401 04 04b0 04b0'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }

  void stopLidLock() {
    final packet = RawPacket(
      destination: 'c0',
      source: BeanConfiguration.applictionAddress,
      command: GeaRequest.writeErdRev2,
      data: Uint8StringList.fromString(
          '${(id++).hex1byteString} f401 04 0000 0000'),
    );

    _peripheral?.sendPacket(packet.uint8List);
  }
}
