import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:logger/logger.dart';
import '../db/patient.dart';

class PatientController extends GetxController {
  late final Isar isar;
  var currentPatient = Patient().obs;

  @override
  void onInit() async {
    super.onInit();
    isar = await openIsar();
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

  void setCurrentPatient(Patient patient) {
    currentPatient.value = patient;
  }

  Future<void> savePatientToDatabase() async {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
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
}
