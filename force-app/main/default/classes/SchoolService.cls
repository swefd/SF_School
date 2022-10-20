/**
 * Created by oleksandrchornous on 11/10/22.
 */

public with sharing class SchoolService {
  public static void enrollStudentToClass(Id classId, Id studentId) {
    if (!Utils.isValidSalesforceId(classId)) {
      throw new IllegalArgumentException('Class id is not valid or null');
    }
    if (!Utils.isValidSalesforceId(studentId)) {
      throw new IllegalArgumentException('Student id is not valid or null');
    }

    Class_Enrollment__c newEnrollment = new Class_Enrollment__c(
      Class__c = classId,
      Student__c = studentId
    );

    try {
      insert newEnrollment;
    } catch (DmlException e) {
      System.debug(e.getMessage());
      throw e;
    }
  }

  public static void setGrade(Id classId, Id studentId, Integer grade) {
    List<Class_Enrollment__c> classEnrollments = [
      SELECT Grade__c
      FROM Class_Enrollment__c
      WHERE Class__c = :classId AND Student__c = :studentId
    ];

    for (Class_Enrollment__c classEnrollment : classEnrollments) {
      classEnrollment.Grade__c = grade;
    }

    try {
      update classEnrollments;
    } catch (DmlException e) {
      System.debug(e.getMessage());
      throw e;
    }
  }

  public static void setGrade(Id classEnrollmentId, Integer grade) {
    Class_Enrollment__c classEnrollment = new Class_Enrollment__c(
      Id = classEnrollmentId
    );
    classEnrollment.Grade__c = grade;

    try {
      update classEnrollment;
    } catch (DmlException e) {
      System.debug(e.getMessage());
      throw e;
    }
  }

  public static void setAcademicScholarship(Id studentId) {
    Student__c student = new Student__c(Id = studentId);
    student.Scholarship__c = Scholarship.ACADEMIC;

    try {
      update student;
    } catch (DmlException e) {
      System.debug(e.getMessage());
      throw e;
    }
  }

  public static void setScholarship(Id studentId, String scholarship) {
    Student__c student = new Student__c(Id = studentId);
    student.Scholarship__c = scholarship;

    try {
      update student;
    } catch (DmlException e) {
      System.debug(e.getMessage());
      throw e;
    }
  }

  public static void recalculateScholarship(Id studentId) {
    Student__c student = new Student__c(Id = studentId);

    List<Class_Enrollment__c> classEnrollments = [
      SELECT Grade__c
      FROM Class_Enrollment__c
      WHERE Student__c = :studentId
    ];

    List<Decimal> grades = new List<Decimal>();

    for (Class_Enrollment__c classEnrollment : classEnrollments) {
      if (classEnrollment.Grade__c == null) {
        if (student.Scholarship__c != Scholarship.UNASSIGNED) {
          setScholarship(studentId, Scholarship.UNASSIGNED);
        }
        return;
      }
      grades.add(classEnrollment.Grade__c);
    }

    Decimal averageGrade = MathUtils.calculateAverage(grades);

    if (
      averageGrade >= Scholarship.REGULAR_MIN_GRADE &&
      averageGrade <= Scholarship.REGULAR_THRESHOLD_GRADE &&
      student.Scholarship__c != Scholarship.REGULAR
    ) {
      setScholarship(studentId, Scholarship.REGULAR);
    } else if (
      averageGrade > Scholarship.REGULAR_THRESHOLD_GRADE &&
      student.Scholarship__c != Scholarship.INCREASED
    ) {
      setScholarship(studentId, Scholarship.INCREASED);
    }
  }
}
