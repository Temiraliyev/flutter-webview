import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late WebViewXController webviewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        title: const Text(
          'eCampus.Uz',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: WebViewX(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // height: 600,
          initialContent: "https://ecampus.uz/",
          initialSourceType: SourceType.url,
          onWebViewCreated: (controller) => webviewController = controller,
        ),
      ),
    );
  }
}
