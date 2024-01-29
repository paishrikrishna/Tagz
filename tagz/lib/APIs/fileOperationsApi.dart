import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tagz/Processing/authenticatioFunc.dart';
import 'package:archive/archive.dart';

class file_upload_apis {

  final authFuncObj = AuthenticationFunctions();

  String api_url = 'https://etd2um7v2f.execute-api.ap-south-1.amazonaws.com/default/file_upload?';

  Future<void> fileUploadAction ({required File file,required String labels, String? phoneId})async{
     
    String params = 'name='+file.path.split("/").last.toString()+'&labels='+labels+'&phoneId=$phoneId';

    var request = http.MultipartRequest('POST', Uri.parse(api_url+params));

    var multiport = http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync());

    request.files.add(multiport);

    var response = await request.send();
    final respstr = await response.stream.bytesToString();

    print(respstr);


    //return json.decode(respstr).keys.toList();


  }


  Future<void> _fileUploadAction1 ({required File file,required String labels, String? phoneId})async{
     
    String params = 'name='+file.path.split("/").last.toString()+'&labels='+labels+'&phoneId=$phoneId';

    var request = http.MultipartRequest('POST', Uri.parse(api_url+params));

    var multiport = http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync());

    request.files.add(multiport);

    var response = await request.send();
    final respstr = await response.stream.bytesToString();

    print(respstr);


    //return json.decode(respstr).keys.toList();


  }


  Future<List<String>> fileTagzsAction(String Labels,String Action, String? PhoneId) async{
    List<String> labels = [];

    String api_url = 'https://hs4l0g42b7.execute-api.ap-south-1.amazonaws.com/default/LabelsActions?phoneId=$PhoneId&label=$Labels&action=$Action';
    
    var request = http.MultipartRequest('POST', Uri.parse(api_url));
    var response = await request.send();
    final respstr = await response.stream.bytesToString();

    labels = List<String>.from(json.decode(respstr)['labels']);
    print(labels);


    return labels;
  }


  Future<List<String>> getFileActions(String Labels, String? phoneID) async{
    List<String> files = [];

    String api_url = 'https://babyhjp4lc.execute-api.ap-south-1.amazonaws.com/default/return_docs?phoneId=$phoneID&labels=$Labels';
    
    var request = http.MultipartRequest('POST', Uri.parse(api_url));
    var response = await request.send();
    final respstr = await response.stream.bytesToString();

    files = List<String>.from(json.decode(respstr).keys);
    print(files);


    return files;
  }

  
  Future<String> downloadFile(String url, String fileName) async {
        print(fileName);
        HttpClient httpClient = new HttpClient();
        File file;
        String filePath = '';
        String myUrl = '';
        Directory? directory;
        String ZipFileName = fileName.split('.')[0];
    
        try {
          myUrl = url;
          var request = await httpClient.getUrl(Uri.parse(myUrl));
          var response = await request.close();
          if(response.statusCode == 200) {
            var bytes = await consolidateHttpClientResponseBytes(response);
            if(await _requestPermission(Permission.storage)){
              directory = await getExternalStorageDirectory();
              //String? dir = directory?.path;
              print(directory?.path);
              //filePath = '$dir/$fileName';
              filePath = '/storage/emulated/0/Download/'+'$fileName';
              String ZipFilePath = '/storage/emulated/0/Download/$ZipFileName.zip';
              file = File(filePath);
              await file.writeAsBytes(bytes);
              var encoder = ZipFileEncoder();
              encoder.create(ZipFilePath);
              encoder.addFile(File(filePath));
              await File(filePath).delete();
              encoder.close();

            }else{
              return 'false';
            }
            
          }
          else
            filePath = 'Error code: '+response.statusCode.toString();
        }
        catch(ex){
          filePath = ex.toString();
        }

        print(filePath);
        return filePath;
      }


  Future <bool> _requestPermission(Permission permission) async {
    if(await permission.isGranted){
      return true;
    }else{
      var result = await permission.request();
      if(result == permission.isGranted){
        return true;
      }
      else{
        return false;
      }
    }

  }


  Future<String> BulkdownloadFile(List<String> fileurls) async {
        HttpClient httpClient = new HttpClient();
        File file;
        String filePath = '';
        String myUrl = '';
        Directory? directory;
        String ZipFileName = "Tagz_Data";
        String FileName = "";
        String ZipFilePath = '/storage/emulated/0/Download/$ZipFileName.zip';


        var encoder = ZipFileEncoder();
        encoder.create(ZipFilePath);

        for( int i = 0;i< fileurls.length;i++)
        {
          try {
            
            FileName = fileurls[i].split('/').last;
            myUrl = fileurls[i];
            var request = await httpClient.getUrl(Uri.parse(myUrl));
            var response = await request.close();
            if(response.statusCode == 200) {
              var bytes = await consolidateHttpClientResponseBytes(response);
              if(await _requestPermission(Permission.storage)){
                directory = await getExternalStorageDirectory();
                filePath = '/storage/emulated/0/Download/'+'$FileName';
                file = File(filePath);
                await file.writeAsBytes(bytes);
                encoder.addFile(File(filePath));
                await File(filePath).delete();
              }else{
                return 'false';
              }
              
            }
            else
              filePath = 'Error code: '+response.statusCode.toString();
          }
          catch(ex){
            filePath = ex.toString();
          }
        }

        encoder.close();

        print(filePath);
        return filePath;
  }


}

