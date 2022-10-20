/**
 * Created by oleksandrchornous on 12/10/22.
 */

public with sharing class TestDataFactory {
  
  /**
   * Generates a test set of Students, classes, and enrollments.
   * 1 class for each year of study.
   * 2 enrollments for each class.
   */
  public static void setup() {
    List<Class__c> classes = new List<Class__c>();
    List<Student__c> students = new List<Student__c>();
    List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();

    Map<Class__c, List<Student__c>> classToStudentMap = new Map<Class__c, List<Student__c>>();

    for (Integer i = 1; i < 6; i++) {
      Class__c class_c = createClass(2020, String.valueOf(i));
      List<Student__c> studentsForClass = createStudents(2, i, null);

      classes.add(class_c);
      students.addAll(studentsForClass);
      classToStudentMap.put(class_c, studentsForClass);
    }

    insert classes;
    insert students;

    for (Class__c class_c : classToStudentMap.keySet()) {
      classEnrollments.addAll(assignStudentsToClass(class_c, classToStudentMap.get(class_c)));
    }
    insert classEnrollments;
  }

  public static List<Class_Enrollment__c> assignStudentsToClass(Class__c class_c, List<Student__c> students, Integer grade) {
    List<Class_Enrollment__c> enrollments = new List<Class_Enrollment__c>();

    for (Integer i = 0; i < students.size(); i++) {
      enrollments.add(createClassEnrollment(class_c, students.get(i), grade));
    }

    return enrollments;
  }

  public static List<Class_Enrollment__c> assignStudentsToClass(Class__c class_c, List<Student__c> students) {
    List<Class_Enrollment__c> enrollments = new List<Class_Enrollment__c>();

    for (Integer i = 0; i < students.size(); i++) {
      enrollments.add(createClassEnrollment(class_c, students.get(i)));
    }

    return enrollments;
  }


  public static List<Class_Enrollment__c> assignClassesToStudent(List<Class__c> classes, Student__c student, Integer grade) {
    List<Class_Enrollment__c> enrollments = new List<Class_Enrollment__c>();

    for (Integer i = 0; i < classes.size(); i++) {
      enrollments.add(createClassEnrollment(classes.get(i), student, grade));
    }

    return enrollments;
  }

  public static List<Class_Enrollment__c> assignClassesToStudent(List<Class__c> classes, Student__c student) {
    List<Class_Enrollment__c> enrollments = new List<Class_Enrollment__c>();

    for (Integer i = 0; i < classes.size(); i++) {
      enrollments.add(createClassEnrollment(classes.get(i), student));
    }

    return enrollments;
  }

  public static Class_Enrollment__c createClassEnrollment(Class__c class_c, Student__c student, Integer grade) {
    Class_Enrollment__c enrollment = createClassEnrollment(class_c, student);
    enrollment.Grade__c = grade;
    return enrollment;
  }

  public static Class_Enrollment__c createClassEnrollment(Class__c class_c, Student__c student) {
    return new Class_Enrollment__c(
            Class__c = class_c.Id,
            Student__c = student.Id
    );
  }

  public static List<Student__c> createStudents(Integer amount, Integer YearOfStudy, String scholarshipType) {
    List<Student__c> students = new List<Student__c>();

    for (Integer i = 0; i < amount; i++) {
      Student__c student = new Student__c();
      student.Name = 'Student_' + YearOfStudy + '_' + i;
      student.Email__c = 'student-' + YearOfStudy + '-' + i + '@mail.com';
      student.Scholarship__c =
              scholarshipType != null ?
                      scholarshipType :
                      Scholarship.typesList.get(Math.mod(i, Scholarship.typesList.size()));
      student.Year_of_Study__c = String.valueOf(YearOfStudy);
      students.add(student);
    }

    return students;
  }

  public static List<Class__c> createClasses(Integer amount, Integer year, String yearOfStudy) {
    List<Class__c> classes = new List<Class__c>();

    for (Integer i = 0; i < amount; i++) {
      classes.add(createClass(year, yearOfStudy));
    }

    return classes;
  }

  public static Class__c createClass(Integer year, String yearOfStudy) {
    Class__c class_c = new Class__c();
    class_c.Year__c = String.valueOf(year);
    class_c.Year_of_Study__c = String.valueOf(yearOfStudy);

    return class_c;
  }

//  public static TestBundle createTestBundle(TestBundleOptions options) {
//    TestBundle bundle = new TestBundle();
//
//    List<Class__c> classes = new List<Class__c>();
//    List<Student__c> students = new List<Student__c>();
//    List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();
//
//    Map<Class__c, List<Student__c>> classToStudentMap = new Map<Class__c, List<Student__c>>();
//
//    for (Integer i = 1; i < options. + 1; i++) {
//      Class__c class_c = createClass(options.classesYear, String.valueOf(i));
//      List<Student__c> studentsForClass = createStudents(2, i, null);
//
//      classes.add(class_c);
//      students.addAll(studentsForClass);
//      classToStudentMap.put(class_c, studentsForClass);
//    }
//
//    insert classes;
//    insert students;
//
//    for (Class__c class_c : classToStudentMap.keySet()) {
//      classEnrollments.addAll(assignStudentsToClass(class_c, classToStudentMap.get(class_c)));
//    }
//    insert classEnrollments;
//
//    return new TestBundle();
//  }


//  private static void studentsInit() {
////    students = createStudents(10, 1, 2);
//    Integer amount = 10;
//    Integer amountForEachYear = 2;
//    students = new List<Student__c>();
//    for (Integer i = 0; i < amount / amountForEachYear; i++) {
//      for (Integer j = 0; j < amountForEachYear; j++) {
//        Student__c student = new Student__c();
//        student.Name = 'Student' + (i + j);
//        student.Email__c = 'student' + i + '@mail.com';
//        student.Scholarship__c = scholarship.get(Math.mod(i, scholarship.size()));
//        student.Year_of_Study__c = String.valueOf(i + 1);
//        students.add(student);
//      }
//    }
//
//    insert students;
//  }
//
//  private static void classesInit() {
//    classes = createClasses(5);
//
//    insert classes;
//
////    for (Class__c class_c : [SELECT Id, Name, Year__c FROM Class__c]) {
////      System.debug(class_c);
////    }
//  }

//  private static void classEnrollmentsInit(Integer amount, Integer amountStudentForEachClass) {
//    classEnrollments = new List<Class_Enrollment__c>();
//    //Class__c testClass = [SELECT Id FROM Class__c WHERE Year__c = '2020'];
//    for (Integer i = 0; i < 5; i++) {
//
//      assignStudentsToClass(classes.get(i), students.get(i) )
//      Class_Enrollment__c classEnrollment = new Class_Enrollment__c();
//
//      classEnrollment.Name = 'Enrollment' + i;
//      classEnrollment.Class__c = classes.get(i).Id;
//      classEnrollment.Student__c = students.get(i).Id;
//      classEnrollment.Grade__c = 100 - i;
//
//      classEnrollments.add(classEnrollment);
//    }
//
//    insert classEnrollments;
//  }


//  public static List<Student__c> createStudents(Integer amount, Integer yearOfStudy, Integer amountForEachYear) {
//    students = new List<Student__c>();
//    for (Integer i = 0; i < amount / amountForEachYear; i++) {
//      for (Integer j = 0; j < amountForEachYear; j++) {
//        Student__c student = new Student__c();
//        student.Name = 'Student' + (i + j);
//        student.Email__c = 'student' + i + '@mail.com';
//        student.Scholarship__c = scholarship.get(Math.mod(i, scholarship.size()));
//        student.Year_of_Study__c = String.valueOf(i + 1);
//        students.add(student);
//      }
//    }
//
//    return students;
//  }

  //  public static List<Class_Enrollment__c> createClassEnrollments(Integer amount){
  //    classEnrollments = new List<Class_Enrollment__c>();
  //    for (Integer i = 0; i < amount; i++) {
  //      Class_Enrollment__c classEnrollment = new Class_Enrollment__c();
  //
  //      classEnrollment.Name = 'Enrollment' + i;
  //      classEnrollment.Class__c = classes.get(0).Id;
  //      classEnrollment.Student__c = students.get(i).Id;
  //      classEnrollment.Grade__c = 100 - i;
  //
  //      classEnrollments.add(classEnrollment);
  //    }
  //
  //    return classEnrollments;
  //  }
}
