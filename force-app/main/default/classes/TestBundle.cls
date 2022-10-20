/**
 * Created by oleksandrchornous on 20/10/22.
 */

public with sharing class TestBundle {
  private List<Class__c> classes = new List<Class__c>();
  private List<Student__c> students = new List<Student__c>();
  private List<Class_Enrollment__c> classEnrollments = new List<Class_Enrollment__c>();

  public List<Class__c> getClasses() {
    return classes;
  }
  public List<Student__c> getStudents() {
    return students;
  }
  public List<Class_Enrollment__c> getClassEnrollments() {
    return classEnrollments;
  }

  public void setClasses(List<Class__c> classes) {
    this.classes = classes;
  }

  public void setStudents(List<Student__c> students) {
    this.students = students;
  }
  public void setClassEnrollments(List<Class_Enrollment__c> classEnrollments) {
    this.classEnrollments = classEnrollments;
  }

  public TestBundle(TestBundleOptions options) {

    System.debug('[TestBundle] CONSTRUCTOR');

    this.classes = new List<Class__c>();
    this.students = new List<Student__c>();
    this.classEnrollments = new List<Class_Enrollment__c>();

    Map<Class__c, List<Student__c>> classToStudentMap = new Map<Class__c, List<Student__c>>();

    for (Integer i = 1; i < options.classes.amount + 1; i++) {
      Class__c class_c = TestDataFactory.createClass(options.classes.year, options.classes.yearOfStudy);
      System.debug('--- Class ---');
      System.debug(class_c);
      List<Student__c> studentsForClass =
              TestDataFactory.createStudents(
                      options.students.amount,
                      options.students.yearOfStudy,
                      options.students.scholarshipType);

      this.classes.add(class_c);
      this.students.addAll(studentsForClass);
      classToStudentMap.put(class_c, studentsForClass);
    }

    for (Class__c class_c : this.classes) {
      System.debug(class_c);
    }

    insert classes;
    insert students;

    for (Class__c class_c : classToStudentMap.keySet()) {
      classEnrollments.addAll(TestDataFactory.assignStudentsToClass(class_c, classToStudentMap.get(class_c)));
    }
    insert classEnrollments;

  }

}