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
    Map<Id, Student__c> testStudentsMap = new Map<Id, Student__c>([
            SELECT Average_Grade__c
            FROM Student__c
            LIMIT 10
    ]);


    Test.startTest();
    Map<Id, Decimal> gradeByIds = SchoolDAO.getStudentPerformance(testStudentsMap.keySet());
    Test.stopTest();

    System.assert(
            gradeByIds.keySet().containsAll(testStudentsMap.keySet()),
            'Method should return map with the same students ids as keys'
    );

    Student__c student = testStudentsMap.values().get(0);

    System.assertEquals(
            student.Average_Grade__c,
            gradeByIds.get(student.Id),
            'Average grade for student should be as expected'
    );
  }

  @IsTest
  static void getClassAttendanceTest() {
    Class__c class_c = [
            SELECT Id, Number_of_Students__c
            FROM Class__c
            LIMIT 1
    ];
    Integer number_of_students = (Integer) class_c.Number_of_Students__c;

    Test.startTest();
    Map<Id, Integer> classAttendance = SchoolDAO.getClassAttendance();
    Test.stopTest();

    System.assertEquals(
            number_of_students,
            classAttendance.get(class_c.Id),
            'Should return the same Amount of related student as auto calculated field Number_of_Students__c'
    );
  }

  @IsTest
  static void getTopStudentsTest() {

    Class__c class_c = TestDataFactory.createClass(2020, '1');
    insert class_c;

    List<Student__c> students = TestDataFactory.createStudents(15, 1, Scholarship.UNASSIGNED);
    insert students;

    List<Class_Enrollment__c> enrollments = TestDataFactory.assignStudentsToClass(class_c, students);
    insert enrollments;

    Integer totalEnrollmentsAmount = (Integer) [
            SELECT COUNT(Id) amount
            FROM Class_Enrollment__c
            WHERE Class__c = :class_c.Id
    ].get(0).get('amount');

    System.assertEquals(
            enrollments.size(),
            totalEnrollmentsAmount,
            'Total enrollments amount should be same'
    );


    Test.startTest();
    List<Class_Enrollment__c> resultTopEnrollments = SchoolDAO.getTopStudents(
            class_c.Id
    );
    Test.stopTest();


    System.assertNotEquals(null, resultTopEnrollments, 'The result list should not be null');

    List<Class_Enrollment__c> expectedTopEnrollments = [
            SELECT Student__c, Grade__c
            FROM Class_Enrollment__c
            WHERE Class__c = :class_c.Id
            ORDER BY Grade__c DESC
            LIMIT 10
    ];

    Set<Id> expectedTopEnrollmentsIds = new Set<Id>(
            new Map<Id, Class_Enrollment__c>(expectedTopEnrollments).keySet()
    );
    Set<Id> resultTopEnrollmentsIds = new Set<Id>(
            new Map<Id, Class_Enrollment__c>(resultTopEnrollments).keySet()
    );

    System.assertEquals(
            10,
            resultTopEnrollments.size(),
            'The size of the result list should be 10');
    System.assert(
            resultTopEnrollmentsIds.containsAll(expectedTopEnrollmentsIds),
            'The result list should contain all expected Ids'
    );
    System.assertEquals(
            expectedTopEnrollments.get(0).Grade__c,
            resultTopEnrollments.get(0).Grade__c,
            'The result list should have top-rated enrollment, as expected');
  }

  @IsTest
  static void getStudentsWithScholarshipTest() {
//    TestBundleOptions bundleOptions = new TestBundleOptions();
//    bundleOptions.students
//            .setAmount(5)
//            .setYearOfStudy(3)
//            .setScholarshipType(Scholarship.REGULAR);
//    bundleOptions.classes
//            .setAmount(1)
//            .setYearOfStudy('3')
//            .setYear(2020);
//    bundleOptions.classEnrollment.setGrade((Integer) Scholarship.REGULAR_MIN_GRADE);

//    TestBundle bundle = new TestBundle(bundleOptions);
    Class__c class_c = TestDataFactory.createClass(2020, '3');
    insert class_c;

    List<Student__c> testStudents = new List<Student__c>();

    for (String scholarship : Scholarship.typesList) {
      testStudents.addAll(TestDataFactory.createStudents(3, 3, scholarship));
    }

    insert testStudents;
    insert TestDataFactory.assignStudentsToClass(class_c, testStudents);

    for (Student__c student : testStudents) {
      System.debug(student);
    }

    Test.startTest();
    List<Student__c> students = SchoolDAO.getStudentsWithScholarship(
            class_c.Id
    );
    Test.stopTest();

    System.assertEquals(
            9,
            students.size(),
            'Method should return list with 9 student with scholarship'
    );
  }
}
