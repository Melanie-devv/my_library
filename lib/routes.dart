import 'package:fluro/fluro.dart';
import 'package:my_library/views/auth/forgot_password_view.dart';
import 'package:my_library/views/auth/login_view.dart';
import 'package:my_library/views/auth/register_view.dart';
import 'package:my_library/views/home_view.dart';
import 'package:my_library/views/profile_view.dart';

class Routes {
  static final FluroRouter router = FluroRouter();


  static final Handler _registerHandler = Handler(
    handlerFunc: (context, params) => RegisterView(),
  );

  static final Handler _loginHandler = Handler(
    handlerFunc: (context, params) => LoginView(),
  );

  static final Handler _forgotPasswordHandler = Handler(
    handlerFunc: (context, params) => ForgotPasswordView(),
  );
  static final Handler _profileHandler = Handler(
    handlerFunc: (context, params) => ProfileView(),
  );
  static final Handler _homeHandler = Handler(
    handlerFunc: (context, params) => HomeView(),
  );


  static dynamic defineRoutes() {

    router.define(
      '/register',
      handler: _registerHandler,
      transitionType: TransitionType.inFromBottom,
    );

    router.define(
      '/login',
      handler: _loginHandler,
      transitionType: TransitionType.inFromBottom,
    );

    router.define(
      '/forgot-password',
      handler: _forgotPasswordHandler,
      transitionType: TransitionType.inFromBottom,
    );

    router.define(
      '/profile',
      handler: _profileHandler,
      transitionType: TransitionType.inFromBottom,
    );

    router.define(
      '/home',
      handler: _homeHandler,
      transitionType: TransitionType.inFromBottom,
    );
  }
}
