// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var container = Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: const Color(0xFFB6B6B6)),
//               color: const Color(0xFFF1F2F7),
//             ),
//             child: Container(
//   padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         margin: const EdgeInsets.fromLTRB(30, 0, 30, 18),
//         child: const Align(
//           alignment: Alignment.center,
//           child: SizedBox(
//             width: 212.1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트를 왼쪽과 오른쪽에 배치
//               children: [
//                 Icon(
//                   Icons.arrow_back_ios, // 아이콘 사용
//                   color: Colors.black,
//                 ),
//                 Text(
//                   '마이페이지',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     // 'Roboto Condensed',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20,
//                     letterSpacing: 0,
//                     color: Color(0xFF000000),
//                   ),
//                 ),
//                 SizedBox(width: 25), // 아이콘과 텍스트 사이의 간격
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),
// ),

//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(17, 0, 17, 17),
                   
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFEFFFE),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(16, 13, 14, 14),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: 25,
//                               height: 25,
//                               child: Icon(
//                                 Icons.account_circle, // 아이콘 사용
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             SizedBox(width: 25),
//                             Text(
//                               '이예원',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 // "Roboto Condensed",
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 20,
//                                 height: 1,
//                                 letterSpacing: -0.5,
//                                 color: Color(0xFF000000),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(17, 0, 17, 19),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFEFFFE),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.fromLTRB(29, 23, 25.9, 21),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
//                               child: const Align(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   '몸 상태와 반응등 증상을 꼭 얘기해주세요.',
//                                   style: TextStyle(
//                                     // 'Roboto Condensed',
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14,
//                                     height: 1.3,
//                                     letterSpacing: -0.5,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: SizedBox(
//                                 width: 258.7,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           margin: const EdgeInsets.fromLTRB(
//                                               0, 0, 12, 0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: const Color(0xFF03C95B),
//                                               borderRadius:
//                                                   BorderRadius.circular(17),
//                                             ),
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.fromLTRB(
//                                                       5, 3, 9.2, 11),
//                                               child: const Text(
//                                                 '+',
//                                                 style: TextStyle(
//                                                   // 'Roboto Condensed',
//                                                   fontWeight: FontWeight.w200,
//                                                   fontSize: 40,
//                                                   height: 0.5,
//                                                   letterSpacing: -0.5,
//                                                   color: Color(0xFFFFFFFF),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           margin:
//                                               const EdgeInsets.fromLTRB(0, 7, 0, 7),
//                                           child: Text(
//                                             '병원 진료',
//                                             style: TextStyle(
//                                               // 'Roboto Condensed',
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 13,
//                                               height: 1.5,
//                                               letterSpacing: -0.5,
//                                               color: Color(0xFF000000),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           margin:
//                                               EdgeInsets.fromLTRB(0, 0, 12, 0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Color(0xFFEDEDED),
//                                               borderRadius:
//                                                   BorderRadius.circular(17),
//                                             ),
//                                             child: Container(
//                                               padding: EdgeInsets.fromLTRB(
//                                                   5, 3, 9.2, 11),
//                                               child: Text(
//                                                 '+',
//                                                 style: TextStyle(
//                                                   // 'Roboto Condensed',
//                                                   fontWeight: FontWeight.w200,
//                                                   fontSize: 40,
//                                                   height: 0.5,
//                                                   letterSpacing: -0.5,
//                                                   color: Color(0xFFAAA3A3),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           margin:
//                                               EdgeInsets.fromLTRB(0, 7, 0, 7),
//                                           child: Text(
//                                             '알레르기 반응',
//                                             style: TextStyle(
//                                               // 'Roboto Condensed',
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 13,
//                                               height: 1.5,
//                                               letterSpacing: -0.5,
//                                               color: Color(0xFF000000),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(17, 0, 17, 19),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFEFFFE),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(29, 16.6, 21, 10.8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.fromLTRB(0, 1.4, 10, 3.2),
//                               child: SizedBox(
//                                 width: 239,
//                                 child: Text(
//                                   '알러지 필터링',
//                                   style: TextStyle(
//                                     // 'Roboto Condensed',
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     height: 1.3,
//                                     letterSpacing: -0.5,
//                                     color: Color(0xFF000000),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 25,
//                               height: 24.6,
//                               // child: SvgPicture.network(
//                               //   'assets/vectors/iconarrow_back_ios_26_x2.svg',
//                               // ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(35, 0, 35, 19),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         '설정',
//                         style: TextStyle(
//                           // 'Roboto Condensed',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           height: 1,
//                           letterSpacing: -0.5,
//                           color: Color(0xFF000000),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(17, 0, 17, 24),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFEFFFE),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(27, 12, 21, 17.8),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.fromLTRB(2, 0, 0, 14.8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.fromLTRB(0, 4, 10, 0.2),
//                                     child: SizedBox(
//                                       width: 239,
//                                       child: Text(
//                                         '닉네임 변경',
//                                         style: TextStyle(
//                                           // 'Roboto Condensed',
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           height: 1.3,
//                                           letterSpacing: -0.5,
//                                           color: Color(0xFF000000),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 25,
//                                     height: 24.2,
//                                     // child: SvgPicture.network(
//                                     //   'assets/vectors/iconarrow_back_ios_15_x2.svg',
//                                     // ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.fromLTRB(0, 4, 0, 0.2),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         margin:
//                                             EdgeInsets.fromLTRB(0, 0, 0, 17),
//                                         child: Text(
//                                           '비밀번호 변경',
//                                           style: TextStyle(
//                                             // 'Roboto Condensed',
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16,
//                                             height: 1.3,
//                                             letterSpacing: -0.5,
//                                             color: Color(0xFF000000),
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
//                                         child: Align(
//                                           alignment: Alignment.topLeft,
//                                           child: Text(
//                                             '탈퇴하기',
//                                             style: TextStyle(
//                                               // 'Roboto Condensed',
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 16,
//                                               height: 1.3,
//                                               letterSpacing: -0.5,
//                                               color: Color(0xFF000000),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 25,
//                                   height: 61.2,
//                                   // child: SvgPicture.network(
//                                   //   'assets/vectors/iconarrow_back_ios_6_x2.svg',
//                                   // ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(35, 0, 35, 19),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         '추가지원',
//                         style: TextStyle(
//                           // 'Roboto Condensed',
//                           fontWeight: FontWeight.w500,
//                           fontSize: 20,
//                           height: 1,
//                           letterSpacing: -0.5,
//                           color: Color(0xFF000000),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(17, 0, 17, 47),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFEFFFE),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Container(
//                         padding: EdgeInsets.fromLTRB(27, 12, 21, 18.8),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.fromLTRB(2, 0, 0, 14.8),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     margin: EdgeInsets.fromLTRB(0, 4, 10, 0.2),
//                                     child: SizedBox(
//                                       width: 239,
//                                       child: Text(
//                                         '문의하기',
//                                         style: TextStyle(
//                                           // 'Roboto Condensed',
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           height: 1.3,
//                                           letterSpacing: -0.5,
//                                           color: Color(0xFF000000),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 25,
//                                     height: 24.2,
//                                     // child: SvgPicture.network(
//                                     //   'assets/vectors/iconarrow_back_ios_25_x2.svg',
//                                     // ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.fromLTRB(0, 4, 10, 0.2),
//                                   child: SizedBox(
//                                     width: 241,
//                                     child: Text(
//                                       '상품추가',
//                                       style: TextStyle(
//                                         // 'Roboto Condensed',
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16,
//                                         height: 1.3,
//                                         letterSpacing: -0.5,
//                                         color: Color(0xFF000000),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 25,
//                                   height: 24.2,
//                                   // child: SvgPicture.network(
//                                   //   'assets/vectors/iconarrow_back_ios_23_x2.svg',
//                                   // ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF5F5F5),
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(1),
//                                   child: SizedBox(
//                                     width: 12,
//                                     height: 14,
//                                     // child: SvgPicture.network(
//                                     //   'assets/vectors/vector_320_x2.svg',
//                                     // ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 // child: SvgPicture.network(
//                                 //   'assets/vectors/union_x2.svg',
//                                 // ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
    
//               );
//     return MaterialApp(
//         home: Scaffold(
//       // appBar: AppBar(
//       //   title: const Text("마이페이지"),
//       //   backgroundColor: const Color.fromARGB(255, 29, 171, 102),
//       //   leading: IconButton(
//       //     icon: const Icon(Icons.arrow_back),
//       //     onPressed: () {
//       //       Navigator.pop(context);
//       //     },
//       //   ),
//       // ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: container,
//             ),
//           ),
//         ),
//       );
//   }
// }