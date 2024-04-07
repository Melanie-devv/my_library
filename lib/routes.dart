import 'package:fluro/fluro.dart';
import 'package:my_library/views/admin/administration_view.dart';
import 'package:my_library/views/auteur_detail_view.dart';
import 'package:my_library/views/auth/forgot_password_view.dart';
import 'package:my_library/views/auth/login_view.dart';
import 'package:my_library/views/auth/register_view.dart';
import 'package:my_library/views/auth/setup_view.dart';
import 'package:my_library/views/auth/welcome.dart';
import 'package:my_library/views/donation_view.dart';
import 'package:my_library/views/favoris_view.dart';
import 'package:my_library/views/home_view.dart';
import 'package:my_library/views/livre_detail_view.dart';
import 'package:my_library/views/pdf_view.dart';
import 'package:my_library/views/profil_donations_view.dart';
import 'package:my_library/views/profil_informations.view.dart';
import 'package:my_library/views/profil_reservations_view.dart';
import 'package:my_library/views/profil_view.dart';
import 'package:my_library/views/reservation_view.dart';

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

  static final Handler _setupHandler = Handler(
    handlerFunc: (context, params) => SetupView(),
  );

  static final Handler _welcomeHandler = Handler(
    handlerFunc: (context, params) => WelcomeView(),
  );

  static final Handler _profileHandler = Handler(
    handlerFunc: (context, params) => ProfilView(),
  );

  static final Handler _homeHandler = Handler(
    handlerFunc: (context, params) => HomeView(),
  );

  static final Handler _favorisHandler = Handler(
    handlerFunc: (context, params) => FavorisView(),
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

  static final Handler _pdfViewHandler = Handler(
    handlerFunc: (context, params) {
      final String url = params['url']![0];
      return PdfView(url: url);
    },
  );

  static final Handler _donationHandler = Handler(
    handlerFunc: (context, params) => DonationView(),
  );

  static final Handler _profilInformationsHandler = Handler(
    handlerFunc: (context, params) => ProfilInformationsView(),
  );

  static final Handler _profilDonationsHandler = Handler(
    handlerFunc: (context, params) => ProfilDonationsView(),
  );

  static final Handler _profilReservationsHandler = Handler(
    handlerFunc: (context, params) => ProfilReservationsView(),
  );

  static final Handler _reservationHandler = Handler(
    handlerFunc: (context, params) {
      final String livreId = params['livreId']![0];
      return ReservationView(livreId: livreId);
    },
  );

  static final Handler _administrationHandler = Handler(
    handlerFunc: (context, params) => AdministrationView(),
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
      '/setup',
      handler: _setupHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/welcome',
      handler: _welcomeHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/profil',
      handler: _profileHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/home',
      handler: _homeHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/favoris',
      handler: _favorisHandler,
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

    router.define(
      '/pdf-view/:url',
      handler: _pdfViewHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/donation',
      handler: _donationHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/profil-informations',
      handler: _profilInformationsHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/profil-donations',
      handler: _profilDonationsHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/profil-reservations',
      handler: _profilReservationsHandler,
      transitionType: TransitionType.inFromRight,
    );

    router.define(
      '/reservation/:livreId',
      handler: _reservationHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/administration',
      handler: _administrationHandler,
      transitionType: TransitionType.fadeIn,
    );
  }
}
