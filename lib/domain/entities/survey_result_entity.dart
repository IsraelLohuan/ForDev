
import 'package:ForDev/domain/entities/entities.dart';
import 'package:meta/meta.dart';

class SurveyResultEntity {
  final String surveyId;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.answers
  });
}