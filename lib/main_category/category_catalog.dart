// 카테고리 화면 상단 가로 목록에 보여줄 "라면/패스트푸드/음료/간식/과자" 정보와,
// 각 카테고리를 눌렀을 때 이동할 화면을 한 곳에 모아둔 파일입니다.
// 이 목록 하나만 고치면 모든 카테고리 화면에 함께 반영됩니다.

import 'package:flutter/material.dart';

import 'bigsnacks.dart';
import 'drink.dart';
import 'instantfood.dart';
import 'ramen.dart';
import 'snacks.dart';

/// 카테고리 하나의 정보: 목록에 보여줄 이름/이미지, 상품 조회에 쓰는 검색어, 이동할 화면.
class CategoryDefinition {
  const CategoryDefinition({
    required this.label,
    required this.imageAsset,
    required this.searchQuery,
    required this.pageBuilder,
  });

  /// 카테고리 목록에 보여줄 이름 (예: '라면').
  final String label;

  /// 카테고리 목록에 보여줄 아이콘 이미지 경로.
  final String imageAsset;

  /// 이 카테고리의 상품을 조회할 때 서버에 보내는 검색어.
  final String searchQuery;

  /// 이 카테고리를 눌렀을 때 이동할 화면을 만드는 함수.
  final WidgetBuilder pageBuilder;
}

Widget _buildRamenScreen(BuildContext context) => const RamenScreen();
Widget _buildInstantfoodScreen(BuildContext context) =>
    const InstantfoodScreen();
Widget _buildDrinkScreen(BuildContext context) => const DrinkScreen();
Widget _buildSnacksScreen(BuildContext context) => const SnacksScreen();
Widget _buildBigsnacksScreen(BuildContext context) => const BigsnacksScreen();

/// 카테고리 화면 상단에서 보여주는 카테고리 목록(고정 순서).
const List<CategoryDefinition> kCategoryDefinitions = [
  CategoryDefinition(
    label: '라면',
    imageAsset: 'assets/images/001.png',
    searchQuery: '라면',
    pageBuilder: _buildRamenScreen,
  ),
  CategoryDefinition(
    label: '패스트푸드',
    imageAsset: 'assets/images/002.png',
    searchQuery: '가공식품',
    pageBuilder: _buildInstantfoodScreen,
  ),
  CategoryDefinition(
    label: '음료',
    imageAsset: 'assets/images/006.png',
    searchQuery: '음료',
    pageBuilder: _buildDrinkScreen,
  ),
  CategoryDefinition(
    label: '간식',
    imageAsset: 'assets/images/007.png',
    searchQuery: '간식',
    pageBuilder: _buildSnacksScreen,
  ),
  CategoryDefinition(
    label: '과자',
    imageAsset: 'assets/images/008.png',
    searchQuery: '과자',
    pageBuilder: _buildBigsnacksScreen,
  ),
];
