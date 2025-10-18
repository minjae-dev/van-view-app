class ApiServices {
  // static final String baseUrl =
  //     dotenv.env['BASE_URL'] ?? 'http://localhost:3001';
  static const String baseUrl = 'http://localhost:3001'; // 백엔드 URL

  final url = Uri.parse(baseUrl);
}
