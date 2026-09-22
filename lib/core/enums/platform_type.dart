enum PlatformType {
  youtube('YouTube', '🔴'),
  instagram('Instagram', '📸'),
  tiktok('TikTok', '🎵'),
  twitter('Twitter/X', '🐦'),
  facebook('Facebook', '🔵'),
  unknown('Unknown', '❓');

  final String displayName;
  final String emoji;
  const PlatformType(this.displayName, this.emoji);
}

