/**
 * Created by oleksandrchornous on 23/10/22.
 */

public with sharing class StudentsWithScholarshipController {
  @AuraEnabled(Cacheable=true)
  public static List<Student__c> getStudentsWithScholarship() {
    return [
            SELECT Id, Name, Scholarship__c, Average_Grade__c
            FROM Student__c
            WHERE Scholarship__c != :Scholarship.UNASSIGNED
    ];
  }
}