import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_project/feature/shared/utils/styles/app_text_style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_project/feature/shared/widgets/shared_app_bar.dart';

@RoutePage()
class CommonWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const CommonWebViewPage({super.key, required this.title, required this.url});

  @override
  State<CommonWebViewPage> createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();

    // Timeout to force hide loader
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _initializeWebView() async {
    try {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFFFFFFF))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );

      if (mounted) {
        setState(() {
          _controllerInitialized = true;
        });
      }

      // Small delay before loading
      await Future.delayed(const Duration(milliseconds: 300));
      await _webViewController.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        isShowBackButton: true,
        centerTitle: true,
        title: widget.title,
        backgroundColor: context.color.white,
        textStyle: AppTextStyle.bodySmallText.copyWith(
          color: context.color.blackColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: _controllerInitialized
          ? Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                if (_isLoading)
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading...', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Initializing...', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
    );
  }
}
