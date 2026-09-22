class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.downees.app'; // Default Backend API placeholder
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints
  static const String videoInfo = '/api/video-info';
  static const String downloadUrl = '/api/download';
}

