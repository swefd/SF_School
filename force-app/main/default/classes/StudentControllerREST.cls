/**
 * Created by oleksandrchornous on 01/11/22.
 */

@RestResource(UrlMapping='/topStudents/*')
global with sharing class StudentControllerREST {
  @HttpGet
  global static List<Student__c> getRecord() {
    Integer amount = 5;

    if (RestContext.request.params.containsKey('amount')) {
      amount = Integer.valueOf(RestContext.request.params.get('amount'));
    }

    return [
            SELECT Id, Name, Average_Grade__c, Scholarship__c, Scholarship_Rate__c
            FROM Student__c
            ORDER BY Average_Grade__c DESC
            LIMIT :amount
    ];
  }
}