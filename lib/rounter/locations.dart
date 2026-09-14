// Beamer 라우터가 "/" 경로에서 보여줄 화면을 지정하는 파일입니다.

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banergy/login/login_FirstApp.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: FirstApp(), key: const ValueKey('home'))];
  }

  @override
  List<String> get pathBlueprints => ['/'];
}
