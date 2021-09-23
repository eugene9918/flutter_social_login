import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } else {
        print('google user is null');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.accessToken != null) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        _auth.signInWithCredential(facebookAuthCredential);
      } else {
        print('loginResult accessToken is null');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signInWithApple() async {
    try {
      final bool isAvailable = await SignInWithApple.isAvailable();
      if (isAvailable) {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: "com.eugenechoe.flutterSocialLogin.serviceId",
            redirectUri: Uri.parse(
                "https://scarlet-caramel-double.glitch.me/callbacks/sign_in_with_apple"),
          ),
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        await _auth.signInWithCredential(oauthCredential);
      } else {
        final clientState = Uuid().v4();
        final url = Uri.https('appleid.apple.com', '/auth/authorize', {
          'response_type': 'code id_token',
          'client_id': "com.eugenechoe.flutterSocialLogin.serviceId",
          'response_mode': 'form_post',
          'redirect_uri':
              'https://scarlet-caramel-double.glitch.me/callbacks/apple/sign_in',
          'scope': 'email name',
          'state': clientState,
        });

        final result = await FlutterWebAuth.authenticate(
            url: url.toString(), callbackUrlScheme: "applink");

        final body = Uri.parse(result).queryParameters;
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: body['id_token'],
          accessToken: body['code'],
        );
        await _auth.signInWithCredential(oauthCredential);
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    _auth.signOut();
  }
}

// https://glitch.com/edit/#!/scarlet-caramel-double?path=server.js%3A86%3A16