import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../state/patients_state.dart';
import '../db/patient.dart';

class PatientEntryForm extends StatelessWidget {
  const PatientEntryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientController controller = Get.find<PatientController>();

    return Flexible(
      flex: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => controller.fetchPatientsFromDatabase(),
                  child: const Text('查询患者信息'),
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                      itemCount: controller.patients.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(controller.patients[index].pID),
                          subtitle: Text(controller.patients[index].name),
                        );
                      })),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.createNewPatient(),
                    child: const Text('新增患者'),
                  ),
      
                  Obx(
                    () => TextField(
                      onChanged: (value) =>
                          controller.currentPatient.value.pID = value,
                      controller: TextEditingController(
                          text: controller.safeGetProperty(
                              () => controller.currentPatient.value.pID, '')),
                      decoration: const InputDecoration(labelText: '患者ID'),
                    ),
                  ),
                  Obx(
                    () => TextField(
                      onChanged: (value) =>
                          controller.currentPatient.value.name = value,
                      controller: TextEditingController(
                          text: controller.safeGetProperty(
                              () => controller.currentPatient.value.name, '')),
                      decoration: const InputDecoration(labelText: '姓名'),
                    ),
                  ),
                  Obx(
                    () => TextField(
                      controller: TextEditingController(
                          text: controller.safeGetProperty(
                              () => controller.currentPatient.value.phoneNumber,
                              '')),
                      onChanged: (value) =>
                          controller.currentPatient.update((val) {
                        val?.phoneNumber = value;
                      }),
                      decoration: const InputDecoration(labelText: '电话号码'),
                    ),
                  ),
                  Obx(
                    () => TextField(
                      controller: TextEditingController(
                          text: controller.safeGetProperty(
                              () => controller.currentPatient.value.address, '')),
                      onChanged: (value) =>
                          controller.currentPatient.update((val) {
                        val?.address = value;
                      }),
                      decoration: const InputDecoration(labelText: '地址'),
                    ),
                  ),
      
                  Obx(
                    () => GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              controller.currentPatient.value.birthdate ??
                                  DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          controller.setBirthdate(pickedDate);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: TextEditingController(
                              text: controller.currentPatient.value.birthdate
                                  ?.toIso8601String()),
                          decoration: const InputDecoration(labelText: '出生日期'),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => DropdownButton<Gender>(
                      value: controller.currentPatient.value.gender,
                      onChanged: (Gender? newValue) {
                        if (newValue != null) {
                          controller.setGender(newValue);
                        }
                      },
                      items: Gender.values
                          .map<DropdownMenuItem<Gender>>((Gender value) {
                        return DropdownMenuItem<Gender>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ),
                  // 其他字段输入框，比如姓名、电话号码等
                  // ...
                  ElevatedButton(
                    onPressed: () {
                      // 当用户点击此按钮时，将患者信息保存到数据库
                      controller.savePatientToDatabase();
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
