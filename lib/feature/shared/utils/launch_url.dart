import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches an email or a specific URL for the given platform and handle.
Future<void> launchEmail(
  String url,
  String platformName,
  String profileHandle,
) async {
  debugPrint("Attempting to open $platformName for handle: $profileHandle");
  debugPrint("URL: $url");

  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      final canLaunchApp = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (canLaunchApp) {
        debugPrint("$platformName opened successfully via app.");
      } else {
        debugPrint(
          "Failed to open $platformName via app. Opening in browser...",
        );
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } else {
      debugPrint("Could not launch $url. Invalid URL.");
    }
  } catch (e) {
    debugPrint("Error launching $platformName for handle $profileHandle: $e");
  }
}

/// Opens Google Maps with the given latitude and longitude.
Future<void> openGoogleMaps({
  required double latitude,
  required double longitude,
  required VoidCallback onFail,
}) async {
  final String googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  debugPrint("Opening Google Maps: $googleMapsUrl");

  try {
    final uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch Google Maps.");
      onFail();
    }
  } catch (e) {
    debugPrint("Error opening Google Maps: $e");
    onFail();
  }
}

/// Launches email app with the given email address and optional subject.
Future<void> launchEmailApp({
  required String email,
  String? subject,
  String? body,
}) async {
  // Only include query parameters if they are not null and not empty
  final Map<String, String> queryParams = {};
  if (subject != null && subject.isNotEmpty) {
    queryParams['subject'] = subject;
  }
  if (body != null && body.isNotEmpty) {
    queryParams['body'] = body;
  }

  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: queryParams.isEmpty ? null : queryParams,
  );

  debugPrint("Attempting to open email app for: $email");
  debugPrint("Email URI: $emailUri");

  try {
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    debugPrint("Email app opened successfully.");
  } catch (e) {
    debugPrint("Error launching email app: $e");
  }
}
