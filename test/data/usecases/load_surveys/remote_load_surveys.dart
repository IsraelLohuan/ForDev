
import 'package:ForDev/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({
    @required this.httpClient,
    @required this.url
  });

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClient httpClient;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
  });

  test('Should call HttpClient with correct values', () async {
    final sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}