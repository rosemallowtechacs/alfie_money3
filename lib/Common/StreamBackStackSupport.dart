import 'dart:async';

enum homePages { screenDashboard, screenPreapproved, screenRepayment }

class StreamBackStackSupport {
  final StreamController<homePages> _homePages = StreamController<homePages>();

  Stream<homePages> get selectedPage => _homePages.stream;

  void switchBetweenPages(homePages selectedPage) {
    _homePages.add(homePages.values[selectedPage.index]);
  }

  void close() {
    _homePages.close();
  }
}