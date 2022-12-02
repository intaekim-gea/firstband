import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'communication_controller.dart';

class CommunicationWidget extends GetView<CommunicationController> {
  final String _tag;

  @override
  String get tag => _tag;

  const CommunicationWidget({required String tag, Key? key})
      : _tag = tag,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: controller.formKey,
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: controller.textEditingController,
                    validator: controller.validator,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      disabledForegroundColor: Colors.grey,
                    ),
                    onPressed: () => controller.sendPacket(),
                    child: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.packetLog.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text('${controller.packetLog[index]}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
