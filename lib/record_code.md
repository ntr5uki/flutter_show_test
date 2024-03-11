# 这里记录一些常用的 代码
## 打印日志相关
### 直接使用
```dart
import 'package:logger/logger.dart';
final logger = Logger();
logger.d(patients.toString()); // 使用.debug, .info, .warning等来替代.d根据需要
```

### logger service
主要用于在系统中打印日志到ApplicationDocumentsDirectory/my_app.log
同时也在命令行输出结果
```dart
final logger = Get.find<LoggerService>().logger;
ogger.i("CustomWidget disposed");
```
同时需要引入
```dart
import 'package:get/get.dart';
import 'class_lib/state/logger_service.dart';
```
### **打印到get dialog**
会弹出对话框
```dart
Get.defaultDialog(
    title: "错误",
    content: Text('连接失败: $e'),
    textCancel: "确认",
);
```
需要引入
```dart
import 'package:get/get.dart';
```
### 其他
flutter的内置图标库
https://api.flutter.dev/flutter/material/Icons-class.html