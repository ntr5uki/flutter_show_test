import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'class_lib/db/patient.dart'; // 确保引入了你的Patient类
import 'dart:io';

void main() async {
  // 初始化Isar数据库
  final isar = await openIsar();

  // 创建一个Patient实例
  final patient = Patient()
    ..pID = '12347'
    ..name = 'John Doe'
    ..phoneNumber = '555-1234'
    ..address = '123 Main St'
    ..birthdate = DateTime(1990, 1, 1)
    ..gender = Gender.male
    ..checks = [
      Check()
        ..filePath = 'path/to/file'
        ..date = DateTime.now()
        ..visitNumber = 'VN123'
        ..department = 'Cardiology'
        ..equipmentType = 'TypeA',
    ];
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: false,
    ),
  ); //引入logger用于打印日志
  // 将Patient对象写入数据库
  try {
    await isar.writeTxn(() async {
      await isar.patients.put(patient);
    });
  } catch (e) {
    logger.e('$e');
    // 处理唯一性违规异常，例如提醒用户pID已存在
  }

  // 从数据库中查询Patient对象
  final patients = await isar.patients.where().findAll();

  // logger.d(patients.toString()); //
  logger.i(patients.toString());
  // print(patients);

  // 查询数据库中的Patient对象
  final patientsBeforeDeletion = await isar.patients.where().findAll();
  logger.i('Patients before deletion: ${patientsBeforeDeletion.length}');

  // 执行删除操作
  try {
    await isar.writeTxn(() async {
      // 假设我们根据pID删除Patient
      final patientToDelete =
          await isar.patients.where().pIDEqualTo(patient.pID).findFirst();
      if (patientToDelete != null) {
        await isar.patients.delete(patientToDelete.id);
        logger.i('Patient deleted');
      } else {
        logger.w('No patient found with pID ${patient.pID}');
      }
    });
  } catch (e) {
    logger.e('Error deleting patient: $e');
  }

  // 再次查询数据库中的Patient对象
  final patientsAfterDeletion = await isar.patients.where().findAll();
  logger.i('Patients after deletion: $patientsAfterDeletion');
}

// Isar数据库的初始化函数

Future<Isar> openIsar() async {
  // 获取应用的文档目录
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = path.join(dir.path, 'my_database');
  final dirname = Directory(dbPath);
  if (!await dirname.exists()) {
    await dirname.create(recursive: true);
  }
  await Isar.initializeIsarCore(download: true);

  // 打开Isar数据库
  return await Isar.open(
    [PatientSchema],
    // 确保引入了正确的模式
    directory: dbPath,
    name: 'patient',
  );
}
