enum DownloadStatus {
  pending,
  fetching,    // Fetching video info
  ready,       // Ready for download preview
  downloading, // Actively downloading
  paused,      // Download paused
  completed,   // Download finished successfully
  failed,      // Download failed
  cancelled;   // Download cancelled by user
}

