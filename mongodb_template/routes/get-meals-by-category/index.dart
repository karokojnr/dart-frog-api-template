import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
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

          final params = request.uri.queryParameters;

          if (params.isNotEmpty) {
            final category = params['category'];
            if (category != null) {
              var mealsList = <Meal>[];

              final record = await mealsCollection
                  .find(
                    where.eq('category', category),
                  )
                  .toList();

              await mongoDbService.closeDb();

              if (record.isEmpty) {
                return Response.json(
                  body: {
                    'status': 201,
                    'message': 'Fetched all meals records successfully',
                    'data': mealsList,
                  },
                );
              }

              mealsList = record
                  .map(
                    (dynamic entry) =>
                        Meal.fromJson(entry as Map<String, dynamic>),
                  )
                  .toList();

              return Response.json(
                body: {
                  'status': 200,
                  'message': 'Fetched all meals records successfully',
                  'data': mealsList,
                },
              );
            }
          }

          return Response.json(
            body: {
              'status': 200,
              'message': 'Invalid request. No parameters found',
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
