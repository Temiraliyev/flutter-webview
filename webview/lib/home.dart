import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum MenuOptions {
  clearCache,
  clearCookies,
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webController;
  double progress = 0;

  late bool isSubmitting;
  String email = '1234';
  String pass = '1234';

  @override
  void initState() {
    super.initState();
    isSubmitting = false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (await _webController.canGoBack()) {
          _webController.goBack();
        } else {
          log('Нет записи в истории');
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WebView'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await _webController.canGoBack()) {
                  _webController.goBack();
                } else {
                  log('Нет записи в истории');
                }
                return;
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                if (await _webController.canGoForward()) {
                  _webController.goForward();
                } else {
                  log('Нет записи в истории');
                }
                return;
              },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => _webController.reload(),
            ),
            PopupMenuButton<MenuOptions>(
              onSelected: (value) {
                switch (value) {
                  case MenuOptions.clearCache:
                    _onClearCache(_webController, context);
                    break;
                  case MenuOptions.clearCookies:
                    _onClearCookies(context);
                    break;
                }
              },
              itemBuilder: (context) => <PopupMenuItem<MenuOptions>>[
                const PopupMenuItem(
                  value: MenuOptions.clearCache,
                  child: Text('Удалить кеш'),
                ),
                const PopupMenuItem(
                  value: MenuOptions.clearCookies,
                  child: Text('Удалить Cookies'),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              color: Colors.red,
              backgroundColor: Colors.black,
            ),
            Expanded(
              child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: 'https://student.fbtuit.uz/dashboard/login',
                  onWebViewCreated: (controller) {
                    _webController = controller;
                  },
                  onProgress: (progress) {
                    this.progress = progress / 100;
                    setState(() {});
                  },
                  onPageStarted: (url) {
                    log('Новый сайт: $url');
                    setState(() {
                      _webController.runJavascriptReturningResult(
                          "if (document.getElementById('formstudentlogin-login')) { document.getElementById('formstudentlogin-login').value='$email'; }");

                      _webController.runJavascriptReturningResult(
                          "if (document.getElementById('formstudentlogin-password')) { document.getElementById('formstudentlogin-password').value='$pass'; }");
                    });
                    // if (url.contains('https://flutter.dev')) {
                    //   Future.delayed(const Duration(microseconds: 300), () {
                    //     _webController.runJavascriptReturningResult(
                    //       "document.getElementsByTagName('footer')[0].style.display='none'",
                    //     );
                    //   });
                    // }
                  },
                  onPageFinished: (url) {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () {
                        _webController.runJavascriptReturningResult(
                            "document.getElementById('formstudentlogin-login').value='$email'");

                        _webController.runJavascriptReturningResult(
                            "document.getElementById('formstudentlogin-password').value='$pass'");
                      },
                    );
                  }

                  // navigationDelegate: (request) {
                  //   if (request.url.startsWith(
                  //       'https://student.fbtuit.uz/dashboard/login')) {
                  //     log('Навигация заблоктрована к $request');
                  //     return NavigationDecision.prevent;
                  //   }
                  //   log('Навигация разрешена к $request');
                  //   return NavigationDecision.navigate;
                  // },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await CookieManager().clearCookies();
    String message = 'Cookies удалены';
    if (!hadCookies) {
      message = 'Cookies все были очищены';
    }
    //  https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration
    if (!mounted) return; // Проверяем, что виджет смонтирован
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await _webController.clearCache();
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Кеш очищен')),
    );
  }
}
