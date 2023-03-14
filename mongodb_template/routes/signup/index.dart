import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_dart/firebase_dart.dart';

import '../../exceptions/firebase_exception_code.dart';
import '../../models/models.dart';
import '../../services/services.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;
    final firebaseService = await context.read<Future<FirebaseService>>();
    final mongoDbService = await context.read<Future<MongoDBService>>();

    switch (request.method) {
      case HttpMethod.post:
        await mongoDbService.openDb();

        final requestBody = await request.body();
        final requestData = jsonDecode(requestBody) as Map<String, dynamic>;
        final userData = AuthUser.fromJson(requestData);

        await firebaseService.firebaseAuth.createUserWithEmailAndPassword(
          email: userData.email!,
          password: userData.password!,
        );

        final userCollection = mongoDbService.database.collection('Users');
        await userCollection.insertOne(userData.toJson());

        await mongoDbService.closeDb();

        return Response.json(
          body: {
            'status': 200,
            'message': 'User registered successfully',
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
    if (e.code == FirebaseExceptionCode.emailAlreadyInUse) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'This email is already registered',
          'error': e.toString(),
        },
      );
    } else if (e.code == FirebaseExceptionCode.invalidEmail) {
      return Response.json(
        body: {
          'status': 200,
          'message': 'The email is not valid',
          'error': e.toString(),
        },
      );
    }

    return Response.json(
      statusCode: 500,
      body: {
        'status': 500,
        'message': 'Something went wrong. Internal server error.',
        'error': e.toString(),
      },
    );
  }
}
