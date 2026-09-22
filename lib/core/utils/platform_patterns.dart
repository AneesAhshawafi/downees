class PlatformPatterns {
  PlatformPatterns._();

  // ─── YouTube ───────────────────────────────────
  static final List<RegExp> youtube = [
    // https://www.youtube.com/watch?v=VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?youtube\.com/watch\?v=([\w-]{11})'),
    // https://youtu.be/VIDEO_ID
    RegExp(r'(?:https?://)?youtu\.be/([\w-]{11})'),
    // https://www.youtube.com/shorts/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?youtube\.com/shorts/([\w-]{11})'),
    // https://youtube.com/embed/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?youtube\.com/embed/([\w-]{11})'),
    // https://m.youtube.com/watch?v=VIDEO_ID
    RegExp(r'(?:https?://)?m\.youtube\.com/watch\?v=([\w-]{11})'),
    // https://music.youtube.com/watch?v=VIDEO_ID
    RegExp(r'(?:https?://)?music\.youtube\.com/watch\?v=([\w-]{11})'),
  ];

  // ─── Instagram ─────────────────────────────────
  static final List<RegExp> instagram = [
    // https://www.instagram.com/reel/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/reel/([\w-]+)'),
    // https://www.instagram.com/reels/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/reels/([\w-]+)'),
    // https://www.instagram.com/p/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/p/([\w-]+)'),
    // https://www.instagram.com/stories/USERNAME/ID/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/stories/[\w.]+/(\d+)'),
    // https://www.instagram.com/tv/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?instagram\.com/tv/([\w-]+)'),
  ];

  // ─── TikTok ────────────────────────────────────
  static final List<RegExp> tiktok = [
    // https://www.tiktok.com/@user/video/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?tiktok\.com/@[\w.]+/video/(\d+)'),
    // https://vm.tiktok.com/CODE/
    RegExp(r'(?:https?://)?vm\.tiktok\.com/([\w-]+)'),
    // https://vt.tiktok.com/CODE/
    RegExp(r'(?:https?://)?vt\.tiktok\.com/([\w-]+)'),
    // https://www.tiktok.com/t/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?tiktok\.com/t/([\w-]+)'),
  ];

  // ─── Twitter/X ─────────────────────────────────
  static final List<RegExp> twitter = [
    // https://twitter.com/user/status/TWEET_ID
    RegExp(r'(?:https?://)?(?:www\.)?twitter\.com/\w+/status/(\d+)'),
    // https://x.com/user/status/TWEET_ID
    RegExp(r'(?:https?://)?(?:www\.)?x\.com/\w+/status/(\d+)'),
    // https://t.co/CODE
    RegExp(r'(?:https?://)?t\.co/([\w-]+)'),
  ];

  // ─── Facebook ──────────────────────────────────
  static final List<RegExp> facebook = [
    // https://www.facebook.com/watch/?v=VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/watch/\?v=(\d+)'),
    // https://www.facebook.com/user/videos/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/[\w.]+/videos/(\d+)'),
    // https://fb.watch/CODE/
    RegExp(r'(?:https?://)?fb\.watch/([\w-]+)'),
    // https://www.facebook.com/reel/VIDEO_ID
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/reel/(\d+)'),
    // https://www.facebook.com/share/v/CODE/
    RegExp(r'(?:https?://)?(?:www\.)?facebook\.com/share/v/([\w-]+)'),
  ];
}

