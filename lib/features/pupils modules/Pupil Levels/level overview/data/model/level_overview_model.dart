// Models
class LevelOverviewData {
  final int bookPagesRead;
  final int totalBookPages;
  final int quizQuestionsAnswered;
  final int totalQuizQuestions;
  final int challengesCompleted;
  final int totalChallenges;
  final int gamesMarked;
  final int totalGames;

  LevelOverviewData({
    required this.bookPagesRead,
    required this.totalBookPages,
    required this.quizQuestionsAnswered,
    required this.totalQuizQuestions,
    required this.challengesCompleted,
    required this.totalChallenges,
    required this.gamesMarked,
    required this.totalGames,
  });

  factory LevelOverviewData.fromJson(Map<String, dynamic> json) {
    return LevelOverviewData(
      bookPagesRead: json['bookPagesRead'] ?? 0,
      totalBookPages: json['totalBookPages'] ?? 0,
      quizQuestionsAnswered: json['quizQuestionsAnswered'] ?? 0,
      totalQuizQuestions: json['totalQuizQuestions'] ?? 0,
      challengesCompleted: json['challengesCompleted'] ?? 0,
      totalChallenges: json['totalChallenges'] ?? 0,
      gamesMarked: json['gamesMarked'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
    );
  }

  // Static data for now
  static LevelOverviewData getStaticData() {
    return LevelOverviewData(
      bookPagesRead: 0,
      totalBookPages: 15,
      quizQuestionsAnswered: 4,
      totalQuizQuestions: 10,
      challengesCompleted: 0,
      totalChallenges: 6,
      gamesMarked: 4,
      totalGames: 5,
    );
  }
}
