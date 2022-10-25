/**
 * Created by oleksandrchornous on 18/10/22.
 */
@IsTest
public with sharing class ClassEnrollmentTriggerTest {

//  @TestSetup
//  static void setup() {
//    TestDataFactory.setup();
//  }

  @IsTest
  static void bulkDuplicate_negativeTest() {
    Class__c newClass = new Class__c(Year_of_Study__c = '1');
    Student__c newStudent = new Student__c(Year_of_Study__c = '1');
    insert newClass;
    insert newStudent;
//    insert new Class_Enrollment__c(Class__c = newClass.Id, Student__c = newStudent.Id);

    List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();
    for (Integer i = 0; i < 2; i++) {
      classEnrollments.add(
              new Class_Enrollment__c(
                      Class__c = newClass.Id,
                      Student__c = newStudent.Id
              )
      );
    }
    Test.startTest();
    Database.SaveResult[] result = Database.insert(classEnrollments, false);
    Test.stopTest();

    System.assert(result[0].isSuccess());
    System.assert(!result[1].isSuccess());
    System.assert(result[1].getErrors().size() > 0);
    System.assertEquals('Bulk duplicate', result[1].getErrors()[0].getMessage());
  }

  @IsTest
  static void bulkInsert_positiveTest() {
    List<Student__c> students = new List<Student__c>();
    List<Class__c> classes = new List<Class__c>();

    for (Integer i = 1; i < 3; i++) {
      students.add(
              new Student__c(
                      Name = 'Student ' + i,
                      Year_of_Study__c = '1'
              ));
    }
    insert students;

    for (Integer i = 0; i < 3; i++) {
      classes.add(new Class__c(
              Year_of_Study__c = '1'
      ));
    }
    insert classes;

    insert new Class_Enrollment__c(
            Class__c = classes[0].Id,
            Student__c = students[0].Id
    );
    List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();
    for (Integer i = 0; i < 2; i++) {
      classEnrollments.add(
              new Class_Enrollment__c(
                      Class__c = classes[i + 1].Id,
                      Student__c = students[i].Id
              )
      );
    }

    Test.startTest();
    Database.SaveResult[] result = Database.insert(classEnrollments, false);
    Test.stopTest();

    for (Database.SaveResult res : result) {
      System.assert(res.isSuccess());
      System.assert(res.getErrors().size() == 0);
    }
    System.assertEquals(3,
            [SELECT Id FROM Class_Enrollment__c].size(),
            '2 new Class Enrolments should be inserted + 1 record that was already inserted earlier.');
  }

  @IsTest
  static void existsDuplicate_test() {
    Class__c newClass = new Class__c(Year_of_Study__c = '1');
    Student__c newStudent = new Student__c(Year_of_Study__c = '1');
    insert newClass;
    insert newStudent;

    insert new Class_Enrollment__c(Student__c = newStudent.Id, Class__c = newClass.Id);

    Class_Enrollment__c classEnrollmentDuplicate =
            new Class_Enrollment__c(Student__c = newStudent.Id, Class__c = newClass.Id);

    Test.startTest();
    Database.SaveResult result = Database.insert(classEnrollmentDuplicate, false);
    Test.stopTest();

    System.assert(!result.isSuccess());
    System.assert(result.getErrors().size() > 0);
    System.assertEquals('classEnrollment with this student and class already exists',
            result.getErrors()[0].getMessage());
  }

  @IsTest
  static void yearOfStudyMatchInsert_test() {
    List<Class__c> classes = new List<Class__c>();
    classes.add(new Class__c(Year_of_Study__c = '1'));
    classes.add(new Class__c(Year_of_Study__c = '2;3'));
    insert classes;

    List<Student__c> students = new List<Student__c>();
    students.add(new Student__c(Year_of_Study__c = '2'));
    students.add(new Student__c(Year_of_Study__c = '2'));
    insert students;

    List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();
    classEnrollments.add(new Class_Enrollment__c(
            Student__c = students.get(0).Id,
            Class__c = classes.get(0).Id)
    );
    classEnrollments.add(new Class_Enrollment__c(
            Student__c = students.get(1).Id,
            Class__c = classes.get(1).Id)
    );


    Test.startTest();
    Database.SaveResult[] result = Database.insert(classEnrollments, false);
    Test.stopTest();

    System.assert(!result[0].isSuccess(), 'First classEnrollment insert should be failed');
    System.assert(result[0].getErrors().size() > 0);
    System.assertEquals('Student should have same year of study as class',
            result[0].getErrors()[0].getMessage());

    System.assert(result[1].isSuccess(), 'Second classEnrollment should be successfully inserted');
  }

  @IsTest
  static void existsDuplicateOnUpdate_test() {
    List<Class__c> classes = new List<Class__c>();
    for (Integer i = 0; i < 4; i++) {
      classes.add(new Class__c(Year_of_Study__c = '1;2'));
    }
    insert classes;

    List<Student__c> students = new List<Student__c>();
    for (Integer i = 0; i < 3; i++) {
      students.add(new Student__c(Year_of_Study__c = '1'));
    }
    insert students;

    List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();
    for (Integer i = 0; i < 3; i++) {
      classEnrollments.add(new Class_Enrollment__c(
              Student__c = students.get(i).Id,
              Class__c = classes.get(i).Id)
      );
    }
    insert classEnrollments;


    List<Class_Enrollment__c> updatedClassEnrollments = new List<Class_Enrollment__c>();

    Class_Enrollment__c invalidEnrollment = classEnrollments.get(0);
    invalidEnrollment.Class__c = classes.get(1).Id;
    invalidEnrollment.Student__c = students.get(1).Id;

    Class_Enrollment__c validEnrollment = classEnrollments.get(2);
    validEnrollment.Class__c = classes.get(3).Id;

    updatedClassEnrollments.add(invalidEnrollment);
    updatedClassEnrollments.add(validEnrollment);


    Test.startTest();
    Database.SaveResult[] result = Database.update(
            updatedClassEnrollments,
            false
    );
    Test.stopTest();

    System.assert(!result[0].isSuccess(), 'First classEnrollment insert should be failed');
    System.assert(result[0].getErrors().size() > 0);
    System.assertEquals('classEnrollment with this student and class already exists',
            result[0].getErrors()[0].getMessage());

    System.assert(result[1].isSuccess(),
            'Second classEnrollment should be successfully inserted');
  }
}
