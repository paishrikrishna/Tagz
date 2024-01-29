import 'dart:io';
import 'package:file_picker/file_picker.dart';



class FileSelectFunct {

  Future<File> SelectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type:FileType.custom ,allowedExtensions: ['pdf']);
    late File selected_file ;

    if(result != null){
      print(result.files.single.path.toString());
      selected_file = File(result.files.single.path.toString());
    }

    return selected_file;
  }

  

}