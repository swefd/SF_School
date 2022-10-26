/**
 * Created by oleksandrchornous on 25/10/22.
 */

public with sharing class StudentController {

  @AuraEnabled(Cacheable=true)
  public static List<Class__c> getRelatedClasses(Id studentId) {
    System.debug(studentId);

    List<Class_Enrollment__c> enrollments = [SELECT Class__c FROM Class_Enrollment__c WHERE Student__c = :studentId];
    Set<Id> classesIds = new Set<Id>();

    for (Class_Enrollment__c classEnrollment : enrollments) {
      classesIds.add(classEnrollment.Class__c);
    }

    List<Class__c> classes = [SELECT Name, Year__c, Year_of_Study__c, Subject__c FROM Class__c WHERE Id IN :classesIds];

    return classes;
  }

}