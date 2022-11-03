/**
 * Created by oleksandrchornous on 30/10/22.
 */

public with sharing class ClassEnrollmentIntegration {
  @AuraEnabled
  public static Boolean remove(Id recordId){
    HttpResponse response = ClassEnrollmentCallouts.remove(recordId);
    if (response.getStatusCode() == 200) {
      return ClassEnrollmentService.remove(recordId);
    }
    return false;
  }
}