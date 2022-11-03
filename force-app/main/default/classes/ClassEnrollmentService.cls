/**
 * Created by oleksandrchornous on 30/10/22.
 */

public with sharing class ClassEnrollmentService {
  @AuraEnabled
  public static Boolean remove(Id recordId){
    if (recordId == null) {
      throw new IllegalArgumentException('recordId is null');
    }
    try {
      delete new Class_Enrollment__c(Id = recordId);
    }catch (DmlException e){
      System.debug(e.getMessage());
      throw e;
    }

    return true;
  }
}