import 'package:dio/dio.dart';
import '../../models/cricket_matches_response_model.dart';

/// API client for cricket data (cricket app-style structure).
/// Same pattern as cricket app: one client, repository wraps it, Riverpod provides both.
/// All .freezed / .g.dart files are generated via build_runner — do not create manually.
class CricketApiClient {
  final Dio _dio;
  final String _baseUrl;

  CricketApiClient(this._dio, {required String baseUrl}) : _baseUrl = baseUrl {
    _dio.options.baseUrl = _baseUrl;
  }

  // Matches list API
  Future<CricketMatchesResponseModel> getMatches({
    required String apiKey,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      'matches',
      queryParameters: {'apikey': apiKey, 'offset': offset},
    );
    return CricketMatchesResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Current matches (live/upcoming/finished) — filter in repository
  Future<CricketMatchesResponseModel> getCurrentMatches({
    required String apiKey,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      'currentMatches',
      queryParameters: {'apikey': apiKey, 'offset': offset},
    );
    return CricketMatchesResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// Match by ID
  Future<CricketMatchesResponseModel> getMatchById({
    required String apiKey,
    required String matchId,
  }) async {
    final response = await _dio.get(
      'match_info',
      queryParameters: {'apikey': apiKey, 'id': matchId},
    );
    return CricketMatchesResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  /// eCricScore — real-time live match scores (only truly live matches)
  Future<Map<String, dynamic>> getCricScore({
    required String apiKey,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      'cricScore',
      queryParameters: {'apikey': apiKey, 'offset': offset},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Series list API
  Future<Map<String, dynamic>> getSeriesList({
    required String apiKey,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      'series',
      queryParameters: {'apikey': apiKey, 'offset': offset},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Series points/standings API
  Future<Map<String, dynamic>> getSeriesPoints({
    required String apiKey,
    required String seriesId,
  }) async {
    final response = await _dio.get(
      'series_points',
      queryParameters: {'apikey': apiKey, 'id': seriesId},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Match scorecard API — full batting/bowling card for a match
  Future<Map<String, dynamic>> getMatchScorecard({
    required String apiKey,
    required String matchId,
  }) async {
    final response = await _dio.get(
      'match_scorecard',
      queryParameters: {'apikey': apiKey, 'id': matchId},
    );
    return response.data as Map<String, dynamic>;
  }
}
