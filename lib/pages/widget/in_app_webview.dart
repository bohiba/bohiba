import 'package:bohiba/services/global_service.dart';

import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;
  const InAppWebViewPage({super.key, required this.url});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => GlobalService.showProgress(),
          onPageFinished: (_) => GlobalService.dismissProgress(),
          onWebResourceError: (error) {
            debugPrint("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        actions: [
          IconButton(
            onPressed: () async {
              await _controller.reload();
            },
            icon: Icon(Remix.refresh_line),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
