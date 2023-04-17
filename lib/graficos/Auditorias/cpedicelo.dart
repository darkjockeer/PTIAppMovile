// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe


import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/drawers/drawerauditoria.dart' as du;

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
bool isSelected=false, grafico2=false, grafico3=false;

List <String> calibre1=['1', '2', '3'];
String imagen='';
String obs='';

class cpedicelo extends StatefulWidget{
    const cpedicelo({Key? key}): super(key: key);
    @override
   // ignore: library_private_types_in_public_api
   _cpedicelo createState() => _cpedicelo();
  }
int i=0;
class _cpedicelo extends State<cpedicelo>{
    late TransformationController controller;
  Animation<Matrix4>? animation;
  final double minScale =1;
  final double maxScale = 4;
      @override
    void initState(){
      contarlargo();
      imagen=du.listim[0];
      obs=du.observaciones[0];
      super.initState();
      controller = TransformationController();
    }

    @override
     void dispose(){
      controller.dispose();
      super.dispose();
     }
    showDialogBox(){
    showDialog(barrierDismissible: false,context: context, builder: ((context) => CupertinoAlertDialog(
      title: const Text('No cuenta con internet'),
      content: const Text('Asegurese de tener una conexión a internet'),
      actions: [
        CupertinoButton.filled(child: const Text('Reintentar'), onPressed: () async {
            Navigator.pop(context);
            var result = await Connectivity().checkConnectivity();
            print(result);
            if(result==ConnectivityResult.none)
            {
              Navigator.of(context).pop;
              
            }
            else
            {
              Navigator.of(context).pop;
            }
        })
      ],
    )));
  } 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar
        (
          centerTitle: true,
          title: Text('Control pedicelo'),
          backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () 
              {
                du.listim=[];
                du.observaciones=[];
                Get.back();
              },
            ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(4, 43, 82, 1)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,),
                  isSelected? Container(
                    width: MediaQuery.of(context).size.width-30,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        isSelected? Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: '#337ab7'.toColor(),
                              border: Border.all(color: '#2e6da4'.toColor(), width: 2)
                            ),
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Grafico 1', style: TextStyle(color:Colors.white),),
                                ],
                              ),
                              onTap: ()
                              {
                                setState(() {
                                    imagen=du.listim[0];
                                  obs=du.observaciones[0];
                                  });
                              },
                            ),
                          ),
                        ):Text(''),
                        grafico2? Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: '#337ab7'.toColor(),
                              border: Border.all(color: '#2e6da4'.toColor(), width: 2)
                            ),
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Grafico 2', style: TextStyle(color:Colors.white),),
                                ],
                              ),
                              onTap: ()
                              {
                                setState(() {
                                    imagen=du.listim[1];
                                  obs=du.observaciones[1];
                                  });
                              },
                            ),
                          ),
                        ):Text(''),
                        grafico3? Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: '#337ab7'.toColor(),
                              border: Border.all(color: '#2e6da4'.toColor(), width: 2)
                            ),
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Grafico 3', style: TextStyle(color:Colors.white),),
                                ],
                              ),
                              onTap: ()
                              {
                                print('hey');
                              },
                            ),
                          ),
                        ):Text(''),
                      ],
                    ),
                  ):Text(''),
                  const SizedBox(
                height: 10,),
              Expanded(child: Container(
                width: MediaQuery.of(context).size.width-10,
                height: MediaQuery.of(context).size.height-150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: SizedBox(
                          width: MediaQuery.of(context).size.width-10,
                          height: MediaQuery.of(context).size.height-150,
                          child: buildImage()
                        ),
                ),
              ),
              SizedBox(height: 15,),
              Text('Observaciones:', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
                 Container(
                  width: MediaQuery.of(context).size.width-50,
                  height: 120,
                  color: Colors.transparent,
                  child: RawScrollbar(
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child:
                      Text(obs, 
                      style: TextStyle(fontSize: 20, color: Colors.white),),
                                  ),
                  ),),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ),
    );
  
}
  void contarlargo()
  {
    if(du.observaciones.length==3)
    {
      isSelected=true;
      grafico2=true;
      grafico3=true;
    }
    else if(du.observaciones.length==2)
    {
      isSelected=true;
      grafico2=true;
      grafico3=false;
    }
    else if(du.observaciones.length==1)
    {
      isSelected=false;
      grafico2=false;
      grafico3=false;
    }
  }

  Widget buildImage()
  {
    return InteractiveViewer(
                            transformationController: controller,
                            minScale: minScale,
                            maxScale: maxScale, 
                            panEnabled: true,
                            onInteractionEnd: (details) {
                            },
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(base64Decode(imagen), fit: BoxFit.fill,))),
                          );
  }
  
  }