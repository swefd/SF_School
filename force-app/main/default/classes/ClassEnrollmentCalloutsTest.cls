/**
 * Created by oleksandrchornous on 30/10/22.
 */

@IsTest
private class ClassEnrollmentCalloutsTest {
  @TestSetup
  static void setup() {
    TestDataFactory.setup();
  }

  @IsTest
  static  void removeCallout_test() {
    Class_Enrollment__c classEnrollment = [SELECT Id FROM Class_Enrollment__c LIMIT 1].get(0);

    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('RemoveClassEnrollment');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    Test.setMock(HttpCalloutMock.class, mock);

    Test.startTest();
      HttpResponse response = ClassEnrollmentCallouts.remove(classEnrollment.Id);
    Test.stopTest();

    System.assertNotEquals(null, response, 'The callout should return not null response.');
    System.assertEquals(200, response.getStatusCode(), 'The status code should be 200.');
  }
}