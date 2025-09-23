import 'model/level_overview_model.dart';

class LevelOverviewRepository {
  Future<LevelOverviewData> getLevelOverviewData(String levelId) async {
    // TODO: Implement API call to fetch level overview data
    // For now, return static data
    await Future.delayed(const Duration(milliseconds: 500));
    return LevelOverviewData.getStaticData();
  }
}
