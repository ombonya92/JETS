class InputValidator {
  const InputValidator._();

  static const int _minPasswordLength = 8;
  static const int _maxFieldLength = 128;

  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _safeNamePattern = RegExp(r"^[a-zA-Z\s'\-]{2,64}$");

  static final RegExp _uppercasePattern = RegExp(r'[A-Z]');
  static final RegExp _lowercasePattern = RegExp(r'[a-z]');
  static final RegExp _digitPattern = RegExp(r'\d');
  static final RegExp _specialPattern = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    if (value.trim().length > _maxFieldLength) return 'Email is too long.';
    if (!_emailPattern.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < _minPasswordLength) {
      return 'Password must be at least $_minPasswordLength characters.';
    }
    if (value.length > _maxFieldLength) return 'Password is too long.';
    if (!_uppercasePattern.hasMatch(value)) {
      return 'Must contain an uppercase letter.';
    }
    if (!_lowercasePattern.hasMatch(value)) {
      return 'Must contain a lowercase letter.';
    }
    if (!_digitPattern.hasMatch(value)) return 'Must contain a number.';
    if (!_specialPattern.hasMatch(value)) {
      return 'Must contain a special character.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != password) return 'Passwords do not match.';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required.';
    if (value.trim().length < 2) return 'Name is too short.';
    if (!_safeNamePattern.hasMatch(value.trim())) {
      return 'Name contains invalid characters.';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required.';
    if (value.trim().length > _maxFieldLength) return '$fieldName is too long.';
    return null;
  }

  static String sanitise(String input) {
    return input.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  }
}