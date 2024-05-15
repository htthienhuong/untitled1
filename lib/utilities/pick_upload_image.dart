import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickImage() async {
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    withData: true,
    type: FileType.image,
  );
  return result;
}
