import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funaabmap/models/artifact.dart';
import 'package:funaabmap/services/repositories.dart';
import 'package:funaabmap/utils/globals.dart';
import 'package:funaabmap/utils/providers.dart';
import 'package:funaabmap/utils/theme.dart';
import 'package:funaabmap/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ArtifactUpsertScreen extends ConsumerStatefulWidget {
  final String? pageId;
  final Artifact? extra;

  const ArtifactUpsertScreen({super.key, this.pageId, this.extra});

  @override
  ConsumerState<ArtifactUpsertScreen> createState() => _ArtifactUpsertScreenState();
}

class _ArtifactUpsertScreenState extends ConsumerState<ArtifactUpsertScreen> {

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<XFile> files = [];

  var title = TextEditingController();
  var desc = TextEditingController();
  var lng = TextEditingController();
  var lat = TextEditingController();
  var width = TextEditingController();
  var length = TextEditingController();

  String? type;

  @override
  void initState() {
    if( widget.extra != null ){
      type = widget.extra!.type;
      title.text = widget.extra!.title;
      desc.text = widget.extra!.description ?? '';
      lng.text = widget.extra!.lng.toString();
      lat.text = widget.extra!.lat.toString();
      width.text = widget.extra!.width?.toString() ?? '';
      length.text = widget.extra!.length.toString() ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);
    bool isAdd = widget.pageId == 'new';

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${!isAdd ? 'Edit' : 'Add'} Artifact',
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500),
        ),
        foregroundColor: whiteColor,
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: isAdd ? [] : [
          IconButton(
            onPressed: () => showDeleteConfirm(process: () async {
              context.push('/load');
              // await Future.delayed(Duration(seconds: 2));
              await (await Repository.artifacts()).deleteOne(where.id(ObjectId.fromHexString(widget.pageId!)));
              int count = 0;
              context.pop();
              Future.delayed(Duration(milliseconds: 100), () => context.pop());
              pagingController.refresh();
            }),
            icon: Icon( CupertinoIcons.delete )
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          children: [
            isAdd ? const SizedBox() : Container(
              child: Text('Artifact id #${widget.pageId}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                labelText: 'Title'
              ),
              maxLength: 50,
              validator: (value) => title.text.isNotEmpty ? null : 'Title field is required',
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 25),
            DropdownButtonFormField(
              hint: Text('Type'),
              value: type,
              items: ['road', 'building', 'landmark'].map((e) => DropdownMenuItem<String>(child: Text('$e'), value: e)).toList(),
              onChanged: (e){
                if(e != null) {
                  setState(() {
                    type = e;
                  });
                }
              },
              validator: (value) => value?.isNotEmpty == true ? null : 'Type field is required',
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: desc,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true
              ),
              maxLines: 10,
              maxLength: 1000,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () async {
                context.push('/load');
                final loc = await determinePosition();

                lat.text = loc.latitude.toString();
                lng.text = loc.longitude.toString();

                setState((){});
                context.pop();
              },
              child: Text('Locate', style: TextStyle(fontSize: 20)),
            ),
            TextFormField(
              controller: lat,
              decoration: InputDecoration(
                  labelText: 'Latitude'
              ),
              keyboardType: TextInputType.number,
              readOnly: true,
              validator: (value) => value?.isNotEmpty == true ? null : 'Latitude field is required',
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: lng,
              decoration: InputDecoration(
                  labelText: 'Longitude'
              ),
              keyboardType: TextInputType.number,
              readOnly: true,
              validator: (value) => value?.isNotEmpty == true ? null : 'Longitude field is required',
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: width,
              decoration: InputDecoration(
                  labelText: 'Artifact Width'
              ),
              keyboardType: TextInputType.number,
              validator: (value) => double.tryParse(value ?? '') != null ? null : 'Invalid width value',
              autovalidateMode: AutovalidateMode.always,
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: length,
              decoration: InputDecoration(
                  labelText: 'Artifact Length'
              ),
              keyboardType: TextInputType.number,
              validator: (value) => double.tryParse(value ?? '') != null ? null : 'Invalid length value',
              autovalidateMode: AutovalidateMode.always,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: Text('Add Medias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate((widget.extra?.medias.length ?? 0) + files.length, (index) {
                final isExistingMedia = index < (widget.extra?.medias.length ?? 0);
                if( !isExistingMedia ) index -= (widget.extra?.medias.length ?? 0);
                final xfile = isExistingMedia ? null : files[index];

                return Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                          if( isExistingMedia ){
                            showDeleteConfirm(process: () => setState(() => widget.extra!.medias.removeAt(index)));
                          } else {
                            files.removeAt(index);
                          }
                        }),
                        child: Text('Delete'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(redColor),
                          foregroundColor: MaterialStateProperty.all(whiteColor),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ))
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                          child: FittedBox(
                            child: isExistingMedia ? Image.network(widget.extra!.medias[index]) : Image.file(File(xfile!.path)),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()..add(
                Container(
                  child: FloatingActionButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.media, allowMultiple: true);
                      if( result != null ){
                        final paths = files.map((e) => e.name).toList();
                        // print(paths);
                        files.addAll(result.files.where((e) => !paths.contains(e.name)).map((e) => e.xFile));
                        setState((){});
                      }
                    },
                    child: Icon(
                      CupertinoIcons.plus,
                      color: whiteColor,
                      size: 30,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                    backgroundColor: primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: TextButton(
                onPressed: () async {
                  if(formKey.currentState?.validate() != true) return;

                  if( files.length + (widget.extra?.medias.length ?? 0) <= 0 ){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('A minimum of 1 media file is required'),
                      elevation: 0,
                    ));
                    return;
                  }

                  context.push('/load');

                  try {
                    List<String> imageUrls = widget.extra?.medias ?? [];
                    final artifact = Artifact(
                      type: type!,
                      width: double.tryParse(width.text) ?? 0,
                      // width of artifact in meters
                      length: double.tryParse(length.text) ?? 0,
                      // length of artifact in meters
                      createdAt: DateTime.now(),
                      createdBy: user!.id!,
                      //logged in user ref,
                      lng: double.parse(lng.text),
                      lat: double.parse(lat.text),
                      title: title.text,
                      description: desc.text,
                    );

                    for (var file in files) {
                      final res = await Dio(BaseOptions(validateStatus: (
                          status) => (status ?? 500) < 500)).post(
                          'https://api.cloudinary.com/v1_1/dtyr7ynw4/${file.mimeType?.split('/').firstOrNull ?? 'image'}/upload',
                          data: FormData.fromMap({
                            'timestamp': DateTime
                                .now()
                                .millisecondsSinceEpoch
                                .toString(),
                            'api_key': '833135428398778',
                            'upload_preset': 'ml_default',
                            'file': await MultipartFile.fromFile(file.path),
                          }));

                      if (res.data?.containsKey('secure_url')) {
                        imageUrls.add(res.data['secure_url']);
                      }
                      // print(res);
                    }

                    // print(imageUrls);
                    final artifacts = await Repository.artifacts();
                    final data = (artifact..medias = imageUrls).toJson();

                    if( isAdd ) {
                      await artifacts.insert(data);
                    } else {
                      data.remove('_id');
                      // print(data);
                      await artifacts.updateOne(where.id(ObjectId.fromHexString(widget.pageId!)), [{'\$set': data}]);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Artifact ${isAdd ? 'created' : 'updated'} successfully'),
                      elevation: 0,
                    ));

                    Future.delayed(const Duration(milliseconds: 100), () => context.pop());
                  } catch(e){
                    // rethrow;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('An error occurred please check the form and try again'),
                      elevation: 0,
                    ));
                  }

                  context.pop();
                  pagingController.refresh();
                },
                child: Text(isAdd ? 'Add' : 'Save'),
                style: primaryButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDeleteConfirm({required Function process}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text('Do you really want to perform this action? P.S This action is irreversible!'),
        actions: [
          TextButton(
              onPressed: () => context.pop(),
              child: Text('Cancel')
          ),
          TextButton(
              onPressed: () {
                context.pop();
                process();
              },
              child: Text('Delete')
          ),
        ],
      ),
    );
  }
}
