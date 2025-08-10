class ApiConstants {
  static const String baseUrl = 'http://192.168.1.102:7000/api';
  static const String userEndpoint = '$baseUrl/user';
  static const String profileUserEndpoint = '$baseUrl/user/all-users';

  static const String transactionEndpoint = '$baseUrl/transaction';
  static const String receptionEndpoint = '$baseUrl/reception';

  static const String classEndpoint = '$baseUrl/classes';
  static const String attendanceEndpoint = '$baseUrl/attendance';
}
