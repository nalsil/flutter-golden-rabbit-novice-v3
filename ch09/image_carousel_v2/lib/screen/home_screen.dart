import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(
    initialPage: 1000000, // 충분히 큰 시작 페이지
  );
  Timer? _autoScrollTimer;
  int? _lastAnimatedPage; // 마지막으로 애니메이션한 페이지

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      print('자동 스크롤 타이머 실행!');

      if (!pageController.hasClients || pageController.page == null) {
        return;
      }

      int currentPage = pageController.page!.toInt();

      // 현재 진행 중인 애니메이션이 있으면 스킵
      if (_lastAnimatedPage != null && _lastAnimatedPage == currentPage) {
        print('이미 애니메이션 진행 중');
        return;
      }

      _lastAnimatedPage = currentPage + 1;
      pageController.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int delta) {
    print('클릭 감지! delta=$delta');

    if (!pageController.hasClients) {
      print('PageController에 클라이언트 없음');
      return;
    }

    if (pageController.page == null) {
      print('pageController.page가 null');
      return;
    }

    int currentPage = pageController.page!.toInt();
    int targetPage = currentPage + delta;

    print('현재 페이지: $currentPage, 이동할 페이지: $targetPage');

    _startAutoScroll(); // 타이머 리셋
    _lastAnimatedPage = targetPage;

    pageController.animateToPage(
      targetPage,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    print('페이지 변경됨: $index');
    _lastAnimatedPage = null; // 페이지 변경 완료, 플래그 해제
    _startAutoScroll(); // 타이머 리셋
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            physics: const PageScrollPhysics(),
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              // 5개 이미지를 무한 반복
              final imageNumber = (index % 5) + 1;
              return Image.asset(
                'asset/img/image_$imageNumber.jpeg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          // 왼쪽 클릭 영역 (이전 이미지)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 100,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _navigateToPage(-1),
              child: Container(),
            ),
          ),
          // 오른쪽 클릭 영역 (다음 이미지)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 100,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _navigateToPage(1),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
