import 'package:flutter/material.dart';
import '../appbar/menu.dart';
import 'appbar/search.dart';
import '../mypage/mypage.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MainpageApp());
}

class MainpageApp extends StatelessWidget {
  const MainpageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식품 알레르기 관리 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식품 알레르기 관리 앱'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 아이콘을 눌렀을 때 검색 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // 메뉴 아이콘을 눌렀을 때의 메뉴 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
          ),
        ],
      ),
      body: const ProductGrid(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        // 상품 아이콘을 가져오거나 사용하는 코드 작성
        return Card(
          child: InkWell(
              onTap: () {
                //아이콘 클릭 시 실행할 동작 추가
                _handleProductClick(context, index);
              },
              child: Column(
                children: [
                  const Icon(Icons.fastfood, size: 48), // 아이콘 예시 (음식 아이콘)
                  Text('Product $index'),
                  Text('Description of Product $index'),
                ],
              )),
        );
      },
    );
  }
}

void _handleProductClick(BuildContext context, int index) {
  // 아이콘 클릭 시 실행할 동작을 여기에 추가
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('상품 정보'),
        content: Text('Product $index의 상세 정보를 표시합니다.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('닫기'),
          ),
        ],
      );
    },
  );
}

//바텀 바 내용 구현
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final QrBarCodeScannerDialog _qrBarCodeScannerDialogPlugin =
      QrBarCodeScannerDialog();
  String? code;

  @override
  Widget build(BuildContext context) {
    //qr 코드 기능
    //final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
    //String? code;
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.adjust),
          label: "Lens",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'My',
        ),
      ],
      onTap: (index) {
        // Handle navigation based on the tapped item index
        if (index == 0) {
          // Home icon is tapped, restart the current page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainpageApp()),
          );
        } else if (index == 1) {
          //qr코드 부분
          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
            context: context,
            onCode: (code) {
              setState(() {
                this.code = code;
              });
            },
          );
        } else if (index == 2) {
          // My icon is tapped, navigate to MypageApp
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MypageApp()),
          );
        }
      },
    );
  }
}
