/// {@template firebase_exception_code}
/// Firebase Auth Exception Code
/// {@template}
abstract class FirebaseExceptionCode {
  /// Credential already in use
  static const String credentialAlreadyInUse = 'credential-already-in-use';

  /// User not found
  static const String userNotFound = 'user-not-found';

  /// Wrong Password
  static const String wrongPassword = 'wrong-password';

  /// Email already in use
  static const String emailAlreadyInUse = 'email-already-in-use';

  /// Invalid Email
  static const String invalidEmail = 'invalid-email';

  /// Too many request has been made by the user
  static const String tooManyRequests = 'too-many-requests';

  /// User disabled
  static const String userDisabled = 'user-disabled';
}
