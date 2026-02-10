import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../cricket_repository.dart';
import '../../remote/api_client/providers/cricket_api_client_provider.dart';

part 'cricket_repository_provider.g.dart';

/// Provides a configured instance of CricketRepository
@riverpod
CricketRepository cricketRepository(CricketRepositoryRef ref) {
  final apiClient = ref.watch(cricketApiClientProvider);
  final apiKey = ref.watch(cricketApiKeyProvider);

  return CricketRepository(
    apiClient: apiClient,
    apiKey: apiKey,
  );
}
