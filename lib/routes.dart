import 'package:fluro/fluro.dart';
import 'package:my_library/views/auteur_detail_view.dart';
import 'package:my_library/views/auth/forgot_password_view.dart';
import 'package:my_library/views/auth/login_view.dart';
import 'package:my_library/views/auth/register_view.dart';
import 'package:my_library/views/home_view.dart';
import 'package:my_library/views/livre_detail_view.dart';
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
  static final Handler _livreDetailHandler = Handler(
    handlerFunc: (context, params) {
      final String livreId = params['id']![0];
      return LivreDetailView(livreId: livreId);
    },
  );

  static final Handler _auteurDetailHandler = Handler(
    handlerFunc: (context, params) {
      final String auteurId = params['id']![0];
      return AuteurDetailView(auteurId: auteurId);
    },
  );


  static dynamic defineRoutes() {

    router.define(
      '/register',
      handler: _registerHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/login',
      handler: _loginHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/forgot-password',
      handler: _forgotPasswordHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/profile',
      handler: _profileHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/home',
      handler: _homeHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/livre/:id',
      handler: _livreDetailHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/auteur/:id',
      handler: _auteurDetailHandler,
      transitionType: TransitionType.fadeIn,
    );
  }
}
