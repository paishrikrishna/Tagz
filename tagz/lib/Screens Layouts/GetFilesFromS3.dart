import 'package:flutter/material.dart';
import 'package:tagz/APIs/fileOperationsApi.dart';
import 'package:tagz/Screens%20Layouts/FileLabelsDialog.dart';

class getFilesScreen extends StatefulWidget{


  const getFilesScreen({super.key, required this.Labelist, required this.labels, required this.allLabels, required this.phoneId});
  final List<String> labels;
  final List<String> Labelist;
  final List<String> allLabels;
  final String phoneId;
  
  
  @override
  State<getFilesScreen> createState() => getFilesScreenState(Labelist: Labelist, labels: labels, allLabels: allLabels, phoneId: phoneId);
  

}


class getFilesScreenState extends State<getFilesScreen>{

  getFilesScreenState({required this.Labelist, required this.labels, required this.allLabels, required this.phoneId});
  final List<String> labels;
  final List<String> Labelist;
  final List<String> allLabels;
  final String phoneId;

  final fileobj = file_upload_apis();

  List<String> reportList = [];
  List<String> selectedReportList = [];
  List<String> selectedFile = [];


  final FileUploadActionObj = file_upload_apis();
  
  

  _showLabelsGetFile(context,labels,allLabels) {
    reportList = allLabels;
    selectedReportList = labels;
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
                        FileUploadActionObj.getFileActions(selectedReportList.join(','),phoneId).then((value) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>getFilesScreen(Labelist: value, labels: selectedReportList,allLabels: reportList,phoneId: phoneId)));
                        });
                        
                      },
                    ),
                  ],
                );
        });
    }



    



  @override
  Widget build(BuildContext context){



    Widget _FileListCard(link){

      selectedFile.add(link);
      bool check = true;
      final makeListTile = ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration:  const BoxDecoration(
                  border:  Border(
                      right:  BorderSide(width: 1.0, color: Color.fromARGB(47, 255, 255, 255)))),
              //child: const Icon(Icons.file_present, color: Colors.black),
              child: Checkbox(value: check, onChanged: (bool? newVal){
                  print(newVal);
                  setState(() {
                    if(newVal == true && selectedFile.contains(link) == false){
                      selectedFile.add(link);
                      check = true;
                    } 
                    else if(newVal == false && selectedFile.contains(link) == true){
                      selectedFile.remove(link);
                      check = false;
                    }
                    print(selectedFile); 
                  });
                }
              ),
            ),
            title:Text(
              link.split('/').last,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            
            trailing: IconButton(
              icon: const Icon(Icons.file_download, color: Colors.black, size: 30.0),
              onPressed: (){
                fileobj.downloadFile(link, link.split('/').last);
              },
            ),
            
      );

       
      final makeCard = Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.898)),
                              child: makeListTile,
                            ),
                        );
            
      return makeCard;
    
    }


    Widget _FilterChips(Labels){

      final ChipWidget = Chip(
                            label: Text(Labels),
                            backgroundColor: Colors.grey[60],
                            elevation: 6.0,
                            shadowColor: Colors.grey[60],
                            padding: EdgeInsets.all(8.0),
                          );
      return ChipWidget;
    };

        
    

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  Labelist.map((item) =>  _FileListCard(item)).toList(),
            ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showLabelsGetFile(context,labels,allLabels);
        },
        label: const Text('Change Label'),
        icon: const Icon(Icons.edit,color: Colors.white),
        backgroundColor: Color.fromARGB(255, 12, 97, 136),
      ),*/

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          
          Padding(
            padding: EdgeInsets.only(bottom:3),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showLabelsGetFile(context,labels,allLabels);
                },
                label: const Text('Change\nTagz'),
                icon: const Icon(Icons.edit,color: Colors.white),
                backgroundColor: Color.fromARGB(255, 12, 97, 136),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
               fileobj.BulkdownloadFile(selectedFile);
              },
              label: const Text('Download\nselected'),
              icon: const Icon(Icons.download,color: Colors.white),
              backgroundColor: Color.fromARGB(255, 12, 97, 136),
            ),
          ),

        ],
      )

      
    );
  }
  
}
