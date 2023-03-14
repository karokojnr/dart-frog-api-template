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
        case HttpMethod.get:
          final snapshot = await firebaseService.realtimeDatabase
              .reference()
              .child('Meals')
              .once();

          final mapOfMaps =
              Map<String, dynamic>.from(snapshot.value as Map<String, dynamic>);

          final mealsList = mapOfMaps.values
              .map(
                (dynamic entry) => Meal.fromJson(entry as Map<String, dynamic>),
              )
              .toList();

          return Response.json(
            body: {
              'status': 200,
              'message': 'Fetched all meals records successfully',
              'data': mealsList,
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
        statusCode: 500,
        body: {
          'status': 500,
          'message': 'Something went wrong. Internal server error.',
          'error': e.toString(),
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
