/**
 * Created by oleksandrchornous on 12/10/22.
 */
@IsTest
public with sharing class SchoolDAOTest {
  @TestSetup
  static void setup() {
    TestDataFactory.setup();
  }

  @IsTest
  static void getStudentPerformanceTest() {
    Set<Id> allStudents = (new Map<Id, Student__c>(
        [SELECT Id FROM Student__c LIMIT 100]
      ))
      .keySet();

    Student__c studentWithMaxGrade = [
        SELECT Average_Grade__c
        FROM Student__c
        WHERE Name = 'Student0'
      ]
      .get(0);

    Map<Id, Decimal> gradeByIds = SchoolDAO.getStudentPerformance(allStudents);

    Test.startTest();
    System.assert(
      gradeByIds.keySet().containsAll(allStudents),
      'Method should return map with the same students ids as keys'
    );

    System.assertEquals(
      gradeByIds.get(studentWithMaxGrade.Id),
      studentWithMaxGrade.Average_Grade__c,
      'Average grade for student with name "Student0" should be 100'
    );
    Test.stopTest();
  }

  @IsTest
  static void getClassAttendanceTest() {
    Class__c class_c = [
      SELECT Id, Number_of_Students__c
      FROM Class__c
      WHERE Year__c = '2020'
    ];
    Integer number_of_students = (Integer) class_c.Number_of_Students__c;

    Test.startTest();
    Map<Id, Integer> classAttendance = SchoolDAO.getClassAttendance();
    Test.stopTest();

    System.assertEquals(
      number_of_students,
      classAttendance.get(class_c.Id),
      'should return the same Amount of related student as auto calculated field Number_of_Students__c'
    );
  }

  @IsTest
  static void getTopStudentsTest() {
    Id classId = [SELECT Id FROM Class__c WHERE Year__c = '2020'].Id;

    Class_Enrollment__c topEnrollment = [
      SELECT Student__c, Grade__c
      FROM Class_Enrollment__c
      WHERE Class__c = :classId
      ORDER BY Grade__c DESC
      LIMIT 1
    ];

    Test.startTest();
    List<Class_Enrollment__c> classEnrollments = SchoolDAO.getTopStudents(
      classId
    );
    Test.stopTest();

    System.assertEquals(10, classEnrollments.size());
    System.assertEquals(
      topEnrollment.Grade__c,
      classEnrollments.get(0).Grade__c
    );
  }

  @IsTest
  static void getStudentsWithScholarshipTest() {
    Class__c class_c = [SELECT Id FROM Class__c WHERE Year__c = '2020'];

    Test.startTest();
    List<Student__c> students = SchoolDAO.getStudentsWithScholarship(
      class_c.Id
    );
    Test.stopTest();

    System.assertEquals(
      15,
      students.size(),
      '3/4 from 20 students have assigned scholarship__c'
    );
  }
}
