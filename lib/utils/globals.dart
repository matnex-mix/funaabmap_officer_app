import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/artifact.dart';

String appTitle = "FUNAAB MAP";

final PagingController<int, Artifact> pagingController = PagingController(firstPageKey: 0);
