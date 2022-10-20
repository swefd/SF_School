/**
 * Created by oleksandrchornous on 12/10/22.
 */

public with sharing class SchoolDAO {
  public static Map<Id, Decimal> getStudentPerformance(Set<Id> students) {
    Map<Id, Decimal> studentPerformance = new Map<Id, Decimal>();

    for (Student__c student : [
            SELECT Id, Average_Grade__c
            FROM Student__c
            WHERE Id IN :students
    ]) {
      studentPerformance.put(student.Id, student.Average_Grade__c);
    }

    return studentPerformance;
  }

  public static Map<Id, Integer> getClassAttendance() {
    Map<Id, Integer> classAttendance = new Map<Id, Integer>();

    for (AggregateResult aggregateResult : [
            SELECT Class__c classId, COUNT(Id) totalEnrollments
            FROM Class_Enrollment__c
            GROUP BY Class__c
    ]) {
      classAttendance.put(
              (Id) aggregateResult.get('classId'),
              (Integer) aggregateResult.get('totalEnrollments')
      );
    }

    return classAttendance;
  }

  public static List<Class_Enrollment__c> getTopStudents(Id classId) {
    return [
            SELECT Student__c, Grade__c
            FROM Class_Enrollment__c
            WHERE Class__c = :classId
            ORDER BY Grade__c DESC
            LIMIT 10
    ];
  }

  public static List<Student__c> getStudentsWithScholarship(Id classId) {
    return [
            SELECT Id
            FROM Student__c
            WHERE
                    Scholarship__c != :Scholarship.UNASSIGNED
                    AND Id IN (
                            SELECT Student__c
                            FROM Class_Enrollment__c
                            WHERE Class__c = :classId
                    )
    ];
  }
}
