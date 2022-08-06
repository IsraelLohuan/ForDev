
import 'package:forDev/data/http/http.dart';
import 'package:forDev/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:forDev/domain/usecases/usecases.dart';
import 'package:forDev/data/usecases/usecases.dart';
import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {

  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;
  late Map apiResult;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = ParamsFactory.makeAddAccount();
    apiResult = ApiFactory.makeAccountJson();
    httpClient.mockRequest(apiResult);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(() => httpClient.request(
      url: url,
      method: 'post',
      body: {
        'name': params.name,
        'email': params.email, 
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation
      }
    ));
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    httpClient.mockRequestError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () async {
    httpClient.mockRequestError(HttpError.serverError);
  
    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw EmailInUseError if HttpClient return 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);
   
    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final account = await sut.add(params);

    expect(account.token, apiResult['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient return 200 with invalid data', () async {
    httpClient.mockRequest({'invalid_key': 'invalid_value'});

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
