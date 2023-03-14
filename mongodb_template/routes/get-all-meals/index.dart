
import 'package:dart_frog/dart_frog.dart';
import '../../models/models.dart';
import '../../services/services.dart';

Future<Response> onRequest(RequestContext context) async {
  final isAuthenticated = context.read<bool>();

  if (isAuthenticated) {
    try {
      final request = context.request;
      final mongoDbService = await context.read<Future<MongoDBService>>();

      switch (request.method) {
        case HttpMethod.get:
          await mongoDbService.openDb();
          final mealsCollection = mongoDbService.database.collection('Meals');

          final mealsJson = await mealsCollection.find().toList();

          final mealsList = mealsJson
              .map(
                (dynamic entry) => Meal.fromJson(entry as Map<String, dynamic>),
              )
              .toList();
          await mongoDbService.closeDb();

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
