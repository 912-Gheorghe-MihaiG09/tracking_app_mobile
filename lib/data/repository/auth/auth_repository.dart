import 'package:tracking_app/data/domain/user.dart';
import 'package:tracking_app/data/repository/secure_local_storage.dart';
import 'package:tracking_app/data/service/auth_service.dart';


class AuthRepository {
  final SecureLocalStorage _secureLocalStorage;
  final AuthService _authService;

  AuthRepository(this._secureLocalStorage, this._authService);


  Future<User?> login(String email, String password) => _authService.logIn(email, password);


  Future<void> registerUser(User user){
    return _authService.signUp(user);
  }

  signOut() {
    _secureLocalStorage.deleteData(PrefsConstants.secureRefreshToken);
    _secureLocalStorage.deleteData(PrefsConstants.secureKeyIdToken);
  }
}
