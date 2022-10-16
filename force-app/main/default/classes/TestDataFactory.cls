/**
 * Created by oleksandrchornous on 12/10/22.
 */

public with sharing class TestDataFactory {
  private static List<Student__c> students;
  private static List<Class__c> classes;
  private static List<Class_Enrollment__c> classEnrollments;
  private static final List<String> scholarship = new List<String>{
    'Unassigned',
    'Regular',
    'Increased',
    'Academic'
  };

  public static void setup() {
    studentsInit();
    classesInit();
    classEnrollmentsInit();
  }

  private static void studentsInit() {
    students = createStudents(20);

    insert students;
  }

  private static void classesInit() {
    classes = createClasses(20);

    insert classes;
  }

  private static void classEnrollmentsInit() {
    classEnrollments = new List<Class_Enrollment__c>();
    for (Integer i = 0; i < 20; i++) {
      Class_Enrollment__c classEnrollment = new Class_Enrollment__c();

      classEnrollment.Name = 'Enrollment' + i;
      classEnrollment.Class__c = classes.get(0).Id;
      classEnrollment.Student__c = students.get(i).Id;
      classEnrollment.Grade__c = 100 - i;

      classEnrollments.add(classEnrollment);
    }

    insert classEnrollments;
  }

  public static List<Class__c> createClasses(Integer amount) {
    classes = new List<Class__c>();
    classes.add(new Class__c(Year__c = '2020', Year_of_Study__c = '1'));

    for (Integer i = 1; i < amount; i++) {
      Class__c class_c = new Class__c();

      class_c.Year__c = '2021';
      class_c.Year_of_Study__c = '1';

      classes.add(class_c);
    }

    return classes;
  }

  public static List<Student__c> createStudents(Integer amount) {
    students = new List<Student__c>();
    for (Integer i = 0; i < amount; i++) {
      Student__c student = new Student__c();
      student.Name = 'Student' + i;
      student.Email__c = 'student' + i + '@mail.com';
      student.Scholarship__c = scholarship.get(Math.mod(i, scholarship.size()));
      student.Year_of_Study__c = String.valueOf(Math.mod(i, 5) + 1);

      students.add(student);
    }

    return students;
  }

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
