
import 'package:ForDev/data/usecases/load_survey_result/load_survey_result.dart';
import 'package:ForDev/domain/entities/entities.dart';
import 'package:ForDev/domain/helpers/domain_error.dart';
import 'package:ForDev/domain/usecases/load_survey_result.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResultSpy local;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyResult, surveyId);
    return surveyResult;
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}
class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity surveyResult;

  PostExpectation mockRemoteLoadCall() => when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  SurveyResultEntity mockSurveyResult() {
    return SurveyResultEntity(
      surveyId: faker.guid.guid(),
      question: faker.lorem.sentence(),
      answers: [SurveyAnswerEntity(
        answer: faker.lorem.sentence(),
        percent: faker.randomGenerator.integer(100),
        isCurrentAnswer: faker.randomGenerator.boolean()
      )]
    );
  }

  void mockRemoteLoad() {
    surveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local
    );
    mockRemoteLoad();
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyResult, surveyId)).called(1);
  });

  test('Should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, surveyResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccesDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
}