/**
 * Created by oleksandrchornous on 16/10/22.
 */

@IsTest
public with sharing class SchoolServiceTest {
  @TestSetup
  static void setup() {
    TestDataFactory.setup();
  }

  @IsTest
  static void enrollStudentToClass_test() {
    Class__c class_c = TestDataFactory.createClass(2020, '1');
    insert class_c;

    Student__c student =
            TestDataFactory.createStudents(1, 1, Scholarship.REGULAR).get(0);
    insert student;


    Test.startTest();
    {
      SchoolService.enrollStudentToClass(class_c.Id, student.Id);
    }
    Test.stopTest();

    Class_Enrollment__c classEnrollment = [
            SELECT Student__c, Class__c
            FROM Class_Enrollment__c
            WHERE Class__c = :class_c.Id AND Student__c = :student.Id
    ];

    System.assertNotEquals(null, classEnrollment,
            'Class enrollment should be not null');
    System.assertEquals(student.Id, classEnrollment.Student__c,
            'Created class enrollment should be with expected student');
    System.assertEquals(class_c.Id, classEnrollment.Class__c,
            'Created class enrollment should be with expected class');
  }

  @IsTest
  static void setGrade_test_ByStudentAndClass() {
    Integer expectedGrade = 10;

    Class__c testClass = [SELECT Id FROM Class__c LIMIT 1];

    Class_Enrollment__c testEnrollment = [
            SELECT Student__c, Class__c, Grade__c
            FROM Class_Enrollment__c
            LIMIT 1
    ];
    Student__c testStudent = [SELECT Id FROM Student__c WHERE Id = :testEnrollment.Student__c];

//    System.assertNotEquals(
//            expectedGrade,
//            testEnrollment.Grade__c,
//            'Grade should not be equals to expected grade before test'
//    );

    Test.startTest();
    {
      SchoolService.setGrade(testClass.Id, testStudent.Id, expectedGrade);
    }
    Test.stopTest();

    Class_Enrollment__c classEnrollment = [
            SELECT Grade__c
            FROM Class_Enrollment__c
            WHERE Class__c = :testClass.Id AND Student__c = :testStudent.Id
            ORDER BY Grade__c DESC
    ];

    System.assertEquals(expectedGrade, classEnrollment.Grade__c, 'Grade should be as expected');
  }

  @IsTest
  static void setGrade_test_ClassEnrollment() {
    Integer expectedGrade = 10;

    Class_Enrollment__c testEnrollment = [
            SELECT Grade__c
            FROM Class_Enrollment__c
            WHERE Grade__c != :expectedGrade
            LIMIT 1
    ];

//    System.assertNotEquals(
//            expectedGrade,
//            testEnrollment.Grade__c,
//            'Grade should not be equals to expected grade before test'
//    );

    Test.startTest();
    {
      SchoolService.setGrade(testEnrollment.Id, expectedGrade);
    }
    Test.stopTest();

    Class_Enrollment__c classEnrollment = [
            SELECT Grade__c
            FROM Class_Enrollment__c
            WHERE Id = :testEnrollment.Id
    ];

    System.assertEquals(
            expectedGrade,
            classEnrollment.Grade__c,
            'Grade should be equals to expected'
    );
  }

  @IsTest
  static void recalculateScholarship_test_RegularScholarship() {

    Student__c testStudent =
            TestDataFactory.createStudents(1, 1, Scholarship.UNASSIGNED).get(0);
    insert testStudent;

    List<Class__c> testClasses = TestDataFactory.createClasses(10, 1, '1');
    insert testClasses;

    List<Class_Enrollment__c> testEnrollments =
            TestDataFactory.assignClassesToStudent(
                    testClasses,
                    testStudent,
                    (Integer) Scholarship.REGULAR_MIN_GRADE
            );
    insert testEnrollments;

    Student__c student = [
            SELECT Scholarship__c, Average_Grade__c
            FROM Student__c
            WHERE Id = :testStudent.Id
    ];

    System.assertEquals(
            Scholarship.UNASSIGNED,
            student.Scholarship__c,
            'Scholarship should be "Unassigned" before calling method'
    );

    System.assertEquals(
            Scholarship.REGULAR_MIN_GRADE,
            student.Average_Grade__c,
            'Student Average grade should be' + Scholarship.REGULAR_MIN_GRADE
    );

    Test.startTest();
    {
      SchoolService.recalculateScholarship(testStudent.Id);
    }
    Test.stopTest();

    student = [
            SELECT Scholarship__c, Average_Grade__c
            FROM Student__c
            WHERE Id = :testStudent.Id
    ];

    System.assertEquals(
            Scholarship.REGULAR,
            student.Scholarship__c,
            'Student should have "Regular" scholarship after calling recalculateScholarship() method'
    );
  }


  @IsTest
  static void setAcademicScholarship_test() {
    Student__c student = [
            SELECT Scholarship__c
            FROM Student__c
            WHERE Scholarship__c != :Scholarship.ACADEMIC
            LIMIT 1
    ];

    Test.startTest();
    {
      SchoolService.setAcademicScholarship(student.Id);
    }
    Test.stopTest();

    System.assertEquals(
            Scholarship.ACADEMIC,
            [SELECT Id, Scholarship__c FROM Student__c WHERE Id = :student.Id]
                    .Scholarship__c,
            'Scholarship should not "Academic" after calling method'
    );
  }
}
