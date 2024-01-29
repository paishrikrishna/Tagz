
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tagz/APIs/fileOperationsApi.dart';
import 'package:tagz/Processing/authenticatioFunc.dart';
import 'package:tagz/Processing/fileSelectFunc.dart';
import 'package:tagz/Screens%20Layouts/FileLabelsDialog.dart';
import 'package:tagz/Screens%20Layouts/GetFilesFromS3.dart';

class fileUploadScreen extends StatefulWidget{
  
  @override
  State<fileUploadScreen> createState() => fileUploadScreenState();
  

}


class fileUploadScreenState extends State<fileUploadScreen>{

  final FileSelectFunctObj = FileSelectFunct();
  final FileUploadActionObj = file_upload_apis();
  final myController = TextEditingController();
  final authFuncObj = AuthenticationFunctions();

  List<String> reportList = [];

  late File selected_file ;

  List<String> selectedReportList = [];
  String _LableName =  "";
   
  void _handleChange() {
    setState(() {
        _LableName = myController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_handleChange);
  }


   _showReportDialog(context,value,phoneId) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                    title: const Text("Select labels for File"),
                    content: MultiSelectChip(
                              reportList,
                              selectedReportList,
                              onSelectionChanged: (selectedList) {
                                selectedReportList = selectedList;
                              },
                            ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Create Label"),
                        onPressed: (){
                          Navigator.of(context).pop();
                          _showLabelCreation(context, value,phoneId);
                        },
                      ),
                      TextButton(
                        child: const Text("Upload File"),
                        onPressed: (){
                          if(selectedReportList.isNotEmpty){
                            _showLoadingDialog(context);
                            FileUploadActionObj.fileUploadAction(file: value,labels: selectedReportList.join(','),phoneId: phoneId).then((value) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              print(selectedReportList);
                              }
                            );
                          }
                        },
                      )
                    ],
                  );
          });
    }


    _showLoadingDialog(context) {

      double c_width = MediaQuery.of(context).size.width*0.8;
      double c_height = MediaQuery.of(context).size.height*0.3;
      showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                      alignment: Alignment.center,
                      width: c_width,
                      height: c_height,
                      child: CircularProgressIndicator(),
                    );
            });
    }

  


    _showLabelsGetFile(context,phoneID) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                    title: const Text("Select File labels"),
                    content: MultiSelectChip(
                              reportList,
                              selectedReportList,
                              onSelectionChanged: (selectedList) {
                                selectedReportList = selectedList;
                              },
                            ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Find"),
                        onPressed: (){
                          _showLoadingDialog(context);
                          FileUploadActionObj.getFileActions(selectedReportList.join(','),phoneID).then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>getFilesScreen(Labelist: value, labels: selectedReportList,allLabels: reportList,phoneId: phoneID)));
                          });
                          
                        },
                      ),
                    ],
                  );
          });
    }



    _showLabelCreation(context,value,phoneId) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                    title: const Text("Create New label"),
                    content: Wrap(
                      children: [
                        const Text('Label Name'),
                        TextField(
                          controller: myController,
                          autofocus: true,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Back"),
                        onPressed: (){
                          Navigator.of(context).pop();
                          _showReportDialog(context, value,phoneId);
                        },
                      ),
                      TextButton(
                        child: const Text("Save Label"),
                        onPressed: (){
                          //print(_LableName);
                          _showLoadingDialog(context);
                          FileUploadActionObj.fileTagzsAction(_LableName,'Set',phoneId).then((value_1) {
                            FileUploadActionObj.fileTagzsAction("",'Get',phoneId).then((value_1) {
                                setState(() {
                                  reportList = value_1;
                                });
                                
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                _showReportDialog(context, value,phoneId);
                              },
                            );  
                            },
                          );
                        },
                      )
                    ],
                  );
          });
    }







  @override
  Widget build(BuildContext context){

    double c_width = MediaQuery.of(context).size.width*1;
    double c_height = MediaQuery.of(context).size.height*0.5;

    

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Center(
                child:  GestureDetector(
                  onTap: (){
                    setState(() {
                          selectedReportList = [];
                          _showLoadingDialog(context);
                    });
                    
                    authFuncObj.phoneId().then((value){
                      FileUploadActionObj.fileTagzsAction("",'Get',value).then((value_1) {
                          setState(() {
                            reportList = value_1;
                            Navigator.of(context).pop();
                          });
                          _showLabelsGetFile(context,value);
                        
                        }
                      );  
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 247, 243, 243),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: c_height,
                    width: c_width,
                    child: const Center(
                      child: Text(
                        "Get Files",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: false,
                      )  ,
                    )
                  ),
                )
              ),
            ],
          ),
          Row(
            children: [
              Center(
                child:  GestureDetector(
                  onTap: (){
                    setState(() {
                          selectedReportList = [];
                          _showLoadingDialog(context);
                    });
                  authFuncObj.phoneId().then((phoneId){
                      FileUploadActionObj.fileTagzsAction("",'Get',phoneId).then((value_1) {
                        setState(() {
                          reportList = value_1;
                          Navigator.of(context).pop();
                        });
                        
                        FileSelectFunctObj.SelectFile().then((value) {
                            _showReportDialog(context,value,phoneId);
                            print(reportList);
                          }
                        );

                      },
                    );
                    

                  });
                    
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 247, 243, 243),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: c_height,
                    width: c_width,
                    child: const Center(
                      child: Text(
                        "File Upload",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        softWrap: false,
                      )  ,
                    )
                  ),
                )
              ),
            ],
          ),
        ],
      )
    );
  }


}