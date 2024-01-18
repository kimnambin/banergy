import "package:beamer/beamer.dart";
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_banergy/login/login_login.dart';

class HomeLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [BeamPage(child: LoginApp(), key: const ValueKey('home'))];
  }

  @override
  List get pathBlueprints => ['/'];
}
