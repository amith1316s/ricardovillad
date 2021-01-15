import 'dart:convert';
import 'package:baratinha/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class UserService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  final storage = new FlutterSecureStorage();
  final String sharedKey = 'sharedKey';
  int statusCode;
  String msg;
  int logginId;
  BuildContext context;

  void createAndStoreJWTToken(String uid) async {
    var builder = new JWTBuilder();
    var token = builder
      ..expiresAt = new DateTime.now().add(new Duration(hours: 3))
      ..setClaim('data', {'uid': uid})
      ..getToken();

    var signer = new JWTHmacSha256Signer(sharedKey);
    var signedToken = builder.getSignedToken(signer);
    await storage.write(key: 'token', value: signedToken.toString());
  }

  String validateToken(String token) {
    var signer = new JWTHmacSha256Signer(sharedKey);
    var decodedToken = new JWT.parse(token);
    if (decodedToken.verify(signer)) {
      final parts = token.split('.');
      final payload = parts[1];
      final String decoded = B64urlEncRfc7515.decodeUtf8(payload);
      final int expiry = jsonDecode(decoded)['exp'] * 1000;
      final currentDate = DateTime.now().millisecondsSinceEpoch;
      if (currentDate > expiry) {
        return null;
      }
      return jsonDecode(decoded)['data']['uid'];
    }
    return null;
  }

  void logOut(context) async {
    await storage.delete(key: 'token');
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<String> login(String email, String password) async {
    var msg = "success";

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((dynamic user) async {
      final FirebaseUser currentUser = await _auth.currentUser();
      final uid = currentUser.uid;

      QuerySnapshot userData = await _firestore
          .collection('Users')
          .where('login', isEqualTo: email)
          .getDocuments();

      if (userData.documents.length > 0) {
        logginId = userData.documents[0]['logginId'];
      } else {
        QuerySnapshot system =
            await _firestore.collection('System').getDocuments();

        logginId = system.documents[0]['currentUserLoginId'] + 1;

        _firestore
            .collection('Users')
            .add({'login': email, 'loginId': logginId, 'fichas': 5});
      }
      await storage.write(key: 'loginId', value: logginId.toString());

      createAndStoreJWTToken(uid);

      statusCode = 200;
    }).catchError((error) {
      String errorCode = error.code;
      msg = "Something went wrong.";
      switch (errorCode) {
        case "ERROR_USER_NOT_FOUND":
          {
            statusCode = 400;
            msg = "User not found.";
          }
          break;
        case "ERROR_INVALID_EMAIL":
          {
            statusCode = 400;
            msg = "Wrong email.";
          }
          break;
        case "ERROR_WRONG_PASSWORD":
          {
            statusCode = 400;
            msg = "Password is wrong.";
          }
          break;
      }
    });
    return msg;
  }

  Future<String> getUserId() async {
    var token = await storage.read(key: 'token');
    var uid = validateToken(token);
    return uid;
  }

  Future<String> userEmail() async {
    var user = await _auth.currentUser();
    return user.email;
  }
}