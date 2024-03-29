 ///////// ignore: unused_local_variable

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sariyor/features/auth/models/user_data_response.dart';
import 'package:sariyor/features/auth/models/user_register_request.dart';
import 'package:sariyor/features/events/models/event_paginate_response_model.dart';

import 'package:sariyor/utils/web_service/web_service.dart';

void main() {
  var service = WebService.getInstance();
  group('Network Test', () {
    
    test('Register User', () async {
      try {
        var request = UserRegisterRequest(
                firstName: 'bekir',
                lastName: 'gormez',
                username: 'bekirin50tonu1',
                email: 'bgrmz@yandex1.com',
                password: 'password1')
            .toJson();
        var response = await service.post<UserDataResponse>('/auth/register',
            data: request);

        if (response.statusCode == 200) {
          expect(response.data!.data.token, isNotNull);
        }
      } on DioError catch (e) {
        if (e.response!.statusCode == 422) {
          log('ehehehe');
        }
      }
    });

    test('Get Event Paginate', () async {
      try {
        var response = await service.get<EventPaginateResponse>('/event/all',
            queryParameters: {"page": 1},
            options: Options(headers: {
              'Authorization':
                  'Bearer 1|mEixyTqC1ejMkSAlLzKnLkj8iNPY1WPBlMns3QN7'
            }));

        if (response.statusCode == 200) {
          log(response.data!.data.nextPageUrl);
          expect(response.data!.data.events[0].name, isNotNull);
        }
      } on DioError catch (e) {
        if (e.response == null) {
          return log(e.message);
        }
        if (e.response!.statusCode == 422) {
          log('ehehehe');
        }
      }
    });
  });
}
