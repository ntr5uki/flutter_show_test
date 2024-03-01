import 'dart:io';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerService extends GetxService {
  late Logger _logger;

  Future<LoggerService> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/my_app.log';

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printTime: true,
      ), // 用于控制台的日志格式
      output: MultiOutput([
        ConsoleOutput(), // 输出到控制台
        FileOutput(path), // 输出到文件
      ]),
    );

    return this;
  }

  Logger get logger => _logger;
}

class FileOutput extends LogOutput {
  final String filePath;

  FileOutput(this.filePath);

  @override
  void output(OutputEvent event) {
    final String message = event.lines.join('\n');
    File(filePath).writeAsStringSync('$message\n', mode: FileMode.append);
  }
}
