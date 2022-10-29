/**
 * Created by oleksandrchornous on 27/10/22.
 */

@IsTest
public with sharing class MonthlyScholarshipRateProcessorTest {

  @IsTest
  public static void testScheduledJob() {
//    String CRON_EXP = String.valueOf(Datetime.now().addMinutes(2).format('s m H d M ? y'));

    List<Student__c> students = new List<Student__c>();
    for (Integer i = 0; i < Scholarship.typesList.size(); i++) {
      students.addAll(TestDataFactory.createStudents(10, 1, Scholarship.typesList.get(i)));
    }
    insert students;


    Test.startTest();

      MonthlyScholarshipRateProcessor processor = new MonthlyScholarshipRateProcessor();
      Id batchId = Database.executeBatch(processor, 200);
    Test.stopTest();

    Set<Id> studentsIds = new Set<Id>(new Map<Id, Student__c>(students).keySet());

    List<Student__c> updatedStudents = [
            SELECT Id, Scholarship__c, Scholarship_Rate__c
            FROM Student__c
            WHERE Id IN :studentsIds
    ];

    System.assertEquals(null, updatedStudents, 'List should not be null');
    System.assertNotEquals(0, updatedStudents.size(), 'List should not be null');

    for (Student__c student : updatedStudents) {
      System.assertEquals(Scholarship.Rate.get(student.Scholarship__c), student.Scholarship_Rate__c);
    }

  }

}