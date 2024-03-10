import 'package:isar/isar.dart';
part 'patient.g.dart';


@Collection()
class Patient {
  Id id = Isar.autoIncrement; // 自动增长的ID
  @Index(unique: true) // 添加唯一索引
  late String pID; // 患者ID，唯一值

  late String name; // 患者姓名
  late String phoneNumber; // 电话号码
  String? address; // 地址
  DateTime? birthdate; // 出生日期，可为空
  List<Check>? checks; // 检查记录
  @enumerated
  Gender gender = Gender.preferNotToSay; // 性别，使用枚举类型


  @override
  String toString() {
    return '\nPatient{\n'
           '  id: $id,\n'
           '  pID: $pID,\n'
           '  name: $name,\n'
           '  phoneNumber: $phoneNumber,\n'
           '  address: $address,\n'
           '  birthdate: $birthdate,\n'
           '  gender: $gender\n'
           '}';
  }
}

@embedded
class Check {
  late String filePath; // 检查数据路径
  late DateTime date; // 检查日期
  late String visitNumber; // 就诊号
  late String department; // 就诊科室
  late String equipmentType; // 设备类型
}

enum Gender { male, female, other, preferNotToSay } // 定义枚举类型