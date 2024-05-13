import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funaabmap/models/artifact.dart';
import 'package:funaabmap/services/repositories.dart';
import 'package:funaabmap/utils/providers.dart';
import 'package:funaabmap/utils/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../utils/globals.dart';

class ArtifactListScreen extends ConsumerStatefulWidget {
  const ArtifactListScreen({super.key});

  @override
  ConsumerState<ArtifactListScreen> createState() => _ArtifactListScreenState();
}

class _ArtifactListScreenState extends ConsumerState<ArtifactListScreen> {
  static const _pageSize = 20;

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final artifacts = await Repository.artifacts();
      final userId = ref.watch(loggedInUserProvider)!.id!;

      final newItems = await artifacts.find(where.eq('created_by', userId ?? DbRef(artifacts.collectionName, userId)).sortBy('title').skip(pageKey).limit(_pageSize)).map((e) => Artifact.fromJson(e)).toList();
      final isLastPage = newItems.length < _pageSize;

      if (pageKey == 0){
        newItems.insertAll(0, [
          Artifact(title: '', type: '', description: '', createdBy: '', lat: 0, lng: 0),
          Artifact(title: '', type: '', description: '', createdBy: '', lat: 0, lng: 0)
        ]);
      }

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        pagingController.appendPage(newItems, pageKey + newItems.length);
      }
    } catch (error) {
      // rethrow;
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.all(25),
        child: PagedListView<int, Artifact>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Artifact>(
            itemBuilder: (context, item, index) => index == 0 ? Text(
                'Hello ${user?.fullName ?? ''}, here are your artifacts!',
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400)
            ) : index == 1 ? const SizedBox(height: 25) : Card(
              child: ListTile(
                title: Text(item.title),
                onTap: () => context.push('/artifacts/${item.id}', extra: item),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Artifacts', style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500)),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () => pagingController.refresh(),
            icon: Icon(CupertinoIcons.refresh, color: whiteColor)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          CupertinoIcons.plus,
          color: whiteColor,
        ),
        backgroundColor: primaryColor,
        // shape: const CircleBorder(),
        onPressed: () => context.push('/artifacts/new'),
      ),
    );
  }
}
