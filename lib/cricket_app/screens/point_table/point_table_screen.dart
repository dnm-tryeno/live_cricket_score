import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../constants/cricket_colors.dart';
import '../../constants/cricket_text_styles.dart';
import '../../data/repositories/providers/cricket_repository_provider.dart';
/// Point Table Screen
/// Shows point table/standings (dynamic from API)
class PointTableScreen extends ConsumerStatefulWidget {
  const PointTableScreen({super.key});

  @override
  ConsumerState<PointTableScreen> createState() => _PointTableScreenState();
}

class _PointTableScreenState extends ConsumerState<PointTableScreen> {
  int _selectedCategory = 0; // 0: Men, 1: Women
  String _selectedFormat = 'ODI'; // ODI | T20 | Test
  String? _overrideSeriesId;

  // Data same as before: static series IDs (dart-define or defaults)
  static const String _defaultMenSeriesId = String.fromEnvironment(
    'CRICKET_MEN_SERIES_ID',
    defaultValue: '065533e1-290d-4781-b88b-40df404aae5f',
  );
  static const String _defaultWomenSeriesId = String.fromEnvironment(
    'CRICKET_WOMEN_SERIES_ID',
    defaultValue: '8ed81407-ba10-4d5b-9ca5-29c1d511de90',
  );
  static const String _menOdiSeriesId = String.fromEnvironment(
    'CRICKET_MEN_ODI_SERIES_ID',
    defaultValue: _defaultMenSeriesId,
  );
  static const String _menT20SeriesId = String.fromEnvironment(
    'CRICKET_MEN_T20_SERIES_ID',
    defaultValue: _defaultMenSeriesId,
  );
  static const String _menTestSeriesId = String.fromEnvironment(
    'CRICKET_MEN_TEST_SERIES_ID',
    defaultValue: _defaultMenSeriesId,
  );
  static const String _womenOdiSeriesId = String.fromEnvironment(
    'CRICKET_WOMEN_ODI_SERIES_ID',
    defaultValue: _defaultWomenSeriesId,
  );
  static const String _womenT20SeriesId = String.fromEnvironment(
    'CRICKET_WOMEN_T20_SERIES_ID',
    defaultValue: _defaultWomenSeriesId,
  );
  static const String _womenTestSeriesId = String.fromEnvironment(
    'CRICKET_WOMEN_TEST_SERIES_ID',
    defaultValue: _defaultWomenSeriesId,
  );

  List<Map<String, dynamic>> _seriesPoints = [];
  bool _isLoadingPoints = false;
  String? _seriesError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSeriesPoints(
        _effectiveSeriesId(
          format: _selectedFormat,
          category: _selectedCategory,
        ),
      );
    });
  }

  String _effectiveSeriesId({required String format, required int category}) {
    return _overrideSeriesId ??
        _seriesIdForSelection(format: format, category: category);
  }

  String _seriesIdForSelection({
    required String format,
    required int category,
  }) {
    final isWomen = category == 1;
    switch (format) {
      case 'T20':
        return isWomen ? _womenT20SeriesId : _menT20SeriesId;
      case 'Test':
        return isWomen ? _womenTestSeriesId : _menTestSeriesId;
      case 'ODI':
      default:
        return isWomen ? _womenOdiSeriesId : _menOdiSeriesId;
    }
  }

  Future<void> _fetchSeriesPoints(String seriesId) async {
    if (seriesId.isEmpty) {
      setState(() {
        _seriesPoints = [];
        _seriesError =
            'Missing series id. Run with --dart-define=CRICKET_SERIES_ID=SERIES_ID (or per format IDs).';
        _isLoadingPoints = false;
      });
      return;
    }
    setState(() {
      _isLoadingPoints = true;
      _seriesError = null;
    });
    try {
      final repository = ref.read(cricketRepositoryProvider);
      final points = await repository.getSeriesPoints(seriesId);
      debugPrint('Series points: ${points.length} teams');
      setState(() {
        // Sort by points desc, then wins desc.
        final sorted = [...points];
        int ptsOf(Map<String, dynamic> t) {
          final won = _toInt(t['wins'] ?? t['won'] ?? t['win'] ?? t['w']);
          final ties = _toInt(t['ties'] ?? t['tie'] ?? t['t']);
          final nr = _toInt(t['nr'] ?? t['noResult'] ?? t['no_result']);
          // Standard T20 points: Win=2, Tie=1, NR=1 (if API doesn't provide points)
          return _toInt(t['points'] ?? t['pts'] ?? (won * 2 + ties + nr));
        }

        sorted.sort((a, b) {
          final pA = ptsOf(a);
          final pB = ptsOf(b);
          if (pA != pB) return pB.compareTo(pA);
          final wA = _toInt(a['wins'] ?? a['won'] ?? a['win'] ?? a['w']);
          final wB = _toInt(b['wins'] ?? b['won'] ?? b['win'] ?? b['w']);
          return wB.compareTo(wA);
        });

        _seriesPoints = sorted;
        _isLoadingPoints = false;
      });
    } catch (e) {
      debugPrint('Error fetching series points: $e');
      setState(() {
        _seriesError = 'Failed to load point table';
        _isLoadingPoints = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CricketColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: CricketColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CricketColors.textBlack),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Point Table',
          style: CricketTextStyles.headlineMedium.copyWith(
            color: CricketColors.textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildCategorySelector(),
          const SizedBox(height: 12),
          _buildFormatSelector(),
          const SizedBox(height: 16),
          Expanded(child: _buildSeriesPointsView()),
        ],
      ),
    );
  }

  // --- Men/Women Selector ---
  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: CricketColors.backgroundLight.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(child: _buildCategoryTab('Men', 0)),
            const SizedBox(width: 2),
            Expanded(child: _buildCategoryTab('Women', 1)),
          ],
        ),
      ),
    );
  }

  /// Format filter buttons (ODI, T20, TEST) — visible below Men/Women so user doesn't need three dots for filtering
  Widget _buildFormatSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildFormatChip('ODI', 'ODI')),
          const SizedBox(width: 10),
          Expanded(child: _buildFormatChip('T20', 'T20')),
          const SizedBox(width: 10),
          Expanded(child: _buildFormatChip('TEST', 'Test')),
        ],
      ),
    );
  }

  Widget _buildFormatChip(String label, String value) {
    final isSelected = _selectedFormat == value;
    return GestureDetector(
      onTap: () {
        if (_selectedFormat != value) {
          setState(() {
            _selectedFormat = value;
            _overrideSeriesId = null;
            _seriesPoints = [];
          });
          _fetchSeriesPoints(
            _effectiveSeriesId(format: value, category: _selectedCategory),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? CricketColors.primaryBlue
              : CricketColors.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CricketColors.primaryBlue
                : CricketColors.textGrey.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CricketColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          label,
          style: CricketTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? CricketColors.backgroundWhite
                : CricketColors.textBlack,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, int index) {
    final isSelected = _selectedCategory == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_selectedCategory != index) {
          setState(() {
            _selectedCategory = index;
            _overrideSeriesId = null;
            _seriesPoints = [];
          });
          _fetchSeriesPoints(
            _effectiveSeriesId(format: _selectedFormat, category: index),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? CricketColors.backgroundWhite
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: CricketTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? CricketColors.textBlack
                : CricketColors.textGrey,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSeriesPointsView() {
    if (_isLoadingPoints) {
      return const Center(
        child: CircularProgressIndicator(color: CricketColors.primaryBlue),
      );
    }
    if (_seriesError != null) {
      return _buildErrorView(_seriesError!, () {
        _fetchSeriesPoints(
          _seriesIdForSelection(
            format: _selectedFormat,
            category: _selectedCategory,
          ),
        );
      });
    }
    if (_seriesPoints.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.table_chart,
                size: 64,
                color: CricketColors.textGrey.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No standings available',
                style: CricketTextStyles.headlineSmall.copyWith(
                  color: CricketColors.textGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Point table for this tournament is not available yet',
                style: CricketTextStyles.bodyMedium.copyWith(
                  color: CricketColors.textGrey.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Tournament standings header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: CricketColors.backgroundLight,
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: _headerText('Rank', align: TextAlign.center),
              ),
              Expanded(child: _headerText('Teams')),
              SizedBox(
                width: 90,
                child: _headerText('Ratings', align: TextAlign.right),
              ),
              SizedBox(
                width: 90,
                child: _headerText('Points', align: TextAlign.right),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _seriesPoints.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: CricketColors.textGrey.withOpacity(0.2),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final team = _seriesPoints[index];
              final teamName =
                  team['teamname'] ??
                  team['teamName'] ??
                  team['name'] ??
                  'Unknown';
              final teamImg = (team['img'] ?? team['image'] ?? '').toString();
              final won = _toInt(
                team['wins'] ?? team['won'] ?? team['win'] ?? team['w'],
              );
              final ties = _toInt(team['ties'] ?? team['tie'] ?? team['t']);
              final nr = _toInt(
                team['nr'] ?? team['noResult'] ?? team['no_result'],
              );

              // Map to screenshot-like columns:
              // Ratings -> use Matches played (fallback to "matches")
              final ratings = _toInt(
                team['played'] ?? team['matches'] ?? team['p'],
              );
              final pts = _toInt(
                team['points'] ??
                    team['pts'] ??
                    // If API doesn't provide points, use simple \(2*W + 1*T + 1*NR\)
                    (won * 2 + ties + nr),
              );

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: CricketColors.backgroundWhite,
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: CricketTextStyles.bodyMedium.copyWith(
                          color: CricketColors.textBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          if (teamImg.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                teamImg,
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: CricketColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.sports_cricket,
                                    size: 16,
                                    color: CricketColors.textGrey.withOpacity(
                                      0.8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Text(
                              teamName.toString(),
                              style: CricketTextStyles.bodyMedium.copyWith(
                                color: CricketColors.textBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: _cellText(
                        '$ratings',
                        align: TextAlign.right,
                        size: 16,
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        '$pts',
                        textAlign: TextAlign.right,
                        style: CricketTextStyles.bodyMedium.copyWith(
                          color: CricketColors.textBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Error View ---
  Widget _buildErrorView(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CricketColors.accentRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: CricketColors.accentRed,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: CricketTextStyles.bodyMedium.copyWith(
                color: CricketColors.textGrey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: CricketColors.primaryBlue,
                foregroundColor: CricketColors.backgroundWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _headerText(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: CricketTextStyles.bodyMedium.copyWith(
        color: CricketColors.primaryBlue,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _cellText(
    String text, {
    TextAlign align = TextAlign.left,
    double size = 14,
  }) {
    return Text(
      text,
      textAlign: align,
      style: CricketTextStyles.bodyMedium.copyWith(
        color: CricketColors.textBlack,
        fontSize: size,
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }
}
