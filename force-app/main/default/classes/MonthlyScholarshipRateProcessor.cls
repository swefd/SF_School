/**
 * Created by oleksandrchornous on 27/10/22.
 */

public with sharing class MonthlyScholarshipRateProcessor implements Schedulable, Database.Batchable<SObject>, Database.Stateful{



  public Database.QueryLocator start(Database.BatchableContext bc){
    return Database.getQueryLocator('SELECT Id, Scholarship__c, Scholarship_Rate__c FROM Student__c');
  }

  public void execute(Database.BatchableContext bc, List<Student__c> students) {
    List<Student__c> updatedStudents = new List<Student__c>();
    for (Student__c student : students) {
      student.Scholarship_Rate__c = Scholarship.Rate.get(student.Scholarship__c);
      updatedStudents.add(student);
    }
    update updatedStudents;
  }

  public void finish(Database.BatchableContext param1) {
    System.debug('MonthlyScholarshipRateProcessor has finished job');
  }

  public void execute(SchedulableContext sc) {
    MonthlyScholarshipRateProcessor processor = new MonthlyScholarshipRateProcessor();
    Id batchId = Database.executeBatch(processor, 200);
  }
}