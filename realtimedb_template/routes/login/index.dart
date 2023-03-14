import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../config/configurations.dart';
import '../../exceptions/firebase_exception_code.dart';
import '../../models/models.dart';
import '../../services/firebase_service.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;
    final firebaseService = await context.read<Future<FirebaseService>>();

    switch (request.method) {
      case HttpMethod.post:
        final requestBody = await request.body();
        final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
        final userData = AuthUser.fromJson(requestData);
        final credential =
            await firebaseService.firebaseAuth.signInWithEmailAndPassword(
          email: userData.email,
          password: userData.password,
        );
        // generate jwt token
        final token = issueJWTToken(credential.user!.uid);
        return Response.json(
          body: {
            'status': 200,
            'message': 'User logged in successfully',
            'token': token,
          },
        );
      default:
        return Response.json(
          statusCode: 404,
          body: {
            'status': 404,
            'message': 'invalid request',
          },
        );
    }
  } on FirebaseException catch (e) {
    if (e.code == FirebaseExceptionCode.userNotFound) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'No user found for this email',
          'error': e.message,
        },
      );
    } else if (e.code == FirebaseExceptionCode.wrongPassword) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'Password is not correct',
          'error': e.message,
        },
      );
    }

    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Something went wrong. Internal server error.',
        'error': e.message,
      },
    );
  }
}

String issueJWTToken(String usedId) {
  final claimSet = JwtClaim(
    subject: usedId,
    issuer: 'kennedykaroko',
    otherClaims: <String, dynamic>{
      'typ': 'authnresponse',
    },
    maxAge: const Duration(hours: 24),
  );
  final token = issueJwtHS256(claimSet, Configurations.secretJwt);
  return token;
}
