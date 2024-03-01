import 'package:isar/isar.dart';

// part 'user.g.dart';
@Collection()
class Patient {
  // @Id()
  Id id = Isar.autoIncrement; // 自动增长的ID


  late String name; // 患者姓名
  late int age;  // 患者年龄
  DateTime? examDate; 

  // 你可以根据需要添加更多的属性
  // 例如：
  // late String address; // 地址
  DateTime? birthdate; // 出生日期，可为空

}
