import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:logger/logger.dart';
import '../db/patient.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class PatientController extends GetxController {
  late final Isar isar;
  Rx<Patient> currentPatient = Patient().obs;
  RxList<Patient> patients = <Patient>[].obs;
  final TextEditingController pIDController = TextEditingController();

  /// Initializes the state of the patients module.
  /// This method is called when the state is being initialized.
  /// It opens the Isar database and assigns it to the [isar] variable.
  @override
  void onInit() async {
    super.onInit();
    isar = await openIsar();
  }

  T safeGetProperty<T>(T Function() getProperty, T defaultValue) {
    try {
      return getProperty();
    } catch (e) {
      return defaultValue; // 返回默认值
    }
  }

  Future<Isar> openIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(dir.path, 'my_database');
    final dirname = Directory(dbPath);
    if (!await dirname.exists()) {
      await dirname.create(recursive: true);
    }
    await Isar.initializeIsarCore(download: true);

    return await Isar.open(
      [PatientSchema],
      directory: dbPath,
      name: 'patient',
    );
  }

  void setGender(Gender newGender) {
    currentPatient.update((val) {
      val?.gender = newGender;
    });
  }

  void setBirthdate(DateTime newDate) {
    currentPatient.update((val) {
      val?.birthdate = newDate;
    });
  }

  void setCurrentPatient(Patient patient) {
    currentPatient.value = patient;
  }

  void createNewPatient() {
    currentPatient(Patient());
    pIDController.clear();
  }

  Future<void> savePatientToDatabase() async {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        printTime: false,
      ),
    );

    try {
      await isar.writeTxn(() async {
        await isar.patients.put(currentPatient.value);
      });
    } catch (e) {
      logger.e('$e');
      // 这里可以根据错误类型进行更详细的处理
    }
  }

  Future<void> fetchPatientsFromDatabase() async {
    final allPatients = await isar.patients.where().findAll();
    patients.value = allPatients;
  }

  @override
  void onClose() {
    // 当控制器被释放时，清理控制器资源
    pIDController.dispose();
    super.onClose();
  }
}
