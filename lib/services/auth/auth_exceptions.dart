// login exceptions
class UserNotFoundAuthException implements Exception {

}
class WrongPasswordAuthException implements Exception {

}

// register exception
class WeakPasswordAuthException implements Exception {

}
class EmailAlreadyInUseAuthException implements Exception {

}

// register/login exception
class InvalidEmailAuthException implements Exception {

}

// generic exceptions
class GenericAuthException implements Exception {

}
class UserNotLoggedInAuthException implements Exception {

}
class UserDisabledAuthException implements Exception {

}