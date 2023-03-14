import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import '../../models/models.dart';
import '../../services/firebase_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final isAuthenticated = context.read<bool>();

  if (isAuthenticated) {
    try {
      final request = context.request;
      final firebaseService = await context.read<Future<FirebaseService>>();

      switch (request.method) {
        case HttpMethod.post:
          final usersRef =
              firebaseService.realtimeDatabase.reference().child('Meals');

          final requestBody = await request.body();

          final requestData = jsonDecode(requestBody) as Map<String, dynamic>;

          final mealsData = Meal.fromJson(requestData);

          final newMealRecord = usersRef.push();
          await newMealRecord.set(mealsData.toJson());

          return Response.json(
            body: {
              'status': 200,
              'message': 'New Meal added successfully',
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
    } catch (e) {
      return Response.json(
        statusCode: 401,
        body: {
          'status': 401,
          'message': 'Not authorized to perform this request',
        },
      );
    }
  } else {
    return Response.json(
      statusCode: 401,
      body: {
        'status': 401,
        'message': 'Not authorized to perform this request',
      },
    );
  }
}
