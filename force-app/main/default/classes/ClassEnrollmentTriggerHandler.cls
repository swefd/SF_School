/**
 * Created by oleksandrchornous on 18/10/22.
 */

public with sharing class ClassEnrollmentTriggerHandler {
  public static void checkBulkDuplicates(List<Class_Enrollment__c> newClassEnrollments) {
    Map<String, Class_Enrollment__c> stringClassEnrollmentMap = new Map<String, Class_Enrollment__c>();

    for (Class_Enrollment__c classEnrollment : newClassEnrollments) {
      String idsHash =
              String.valueOf(classEnrollment.Class__c) +
                      String.valueOf(classEnrollment.Student__c);
      if (stringClassEnrollmentMap.keySet().contains(idsHash)) {
        classEnrollment.addError('Bulk duplicate');
      } else {
        stringClassEnrollmentMap.put(idsHash, classEnrollment);
      }
    }

    List<Id> students = new List<Id>();
    List<Id> classes = new List<Id>();

    for (Class_Enrollment__c classEnrollment : newClassEnrollments) {
      students.add(classEnrollment.Student__c);
      classes.add(classEnrollment.Class__c);
    }
  }

  public static void checkExistsDuplicates(List<Class_Enrollment__c> newClassEnrollments) {
    List<Id> students = new List<Id>();
    List<Id> classes = new List<Id>();

    for (Class_Enrollment__c classEnrollment : newClassEnrollments) {
      students.add(classEnrollment.Student__c);
      classes.add(classEnrollment.Class__c);
    }

    List<Class_Enrollment__c> similarClassEnrollments;

    if (classes.size() > 0 && students.size() > 0) {
      try {
        similarClassEnrollments = [
                SELECT Student__c, Class__c
                FROM Class_Enrollment__c
                WHERE Class__c IN :classes AND Student__c IN :students
        ];
      } catch (Exception e) {
        similarClassEnrollments = null;
      }
    }

    Map<Id, Id> studentToClassMap = new Map<Id, Id>();

    for (Class_Enrollment__c enrollment : similarClassEnrollments) {
      studentToClassMap.put(enrollment.Student__c, enrollment.Class__c);
    }

    for (Class_Enrollment__c triggeredClassEnrollment : newClassEnrollments) {
      if (studentToClassMap.containsKey(triggeredClassEnrollment.Student__c)) {
        if (studentToClassMap.get(triggeredClassEnrollment.Student__c) == triggeredClassEnrollment.Class__c) {
          triggeredClassEnrollment.addError('classEnrollment with this student and class already exists');
        }
      }
    }
  }

  public static void checkExistsDuplicatesOnUpdate(
          Map<Id, Class_Enrollment__c> oldEnrollments,
          List<Class_Enrollment__c> newEnrollments
  ) {
    List<Class_Enrollment__c> enrollmentsForCheck = new List<Class_Enrollment__c>();

    for (Class_Enrollment__c enrollment : newEnrollments) {
      if (enrollment.Student__c != oldEnrollments.get(enrollment.Id).Student__c ||
              enrollment.Class__c != oldEnrollments.get(enrollment.Id).Class__c
      ) {
        enrollmentsForCheck.add(enrollment);
      }
    }

    if (enrollmentsForCheck.size() > 0) {
      checkExistsDuplicates(enrollmentsForCheck);
    }
  }

  public static void checkYearOfStudy(List<Class_Enrollment__c> newEnrollments) {
    Set<Id> studentsIds = new Set<Id>();
    Set<Id> classesIds = new Set<Id>();

    for (Class_Enrollment__c enrollment : newEnrollments) {
      studentsIds.add(enrollment.Student__c);
      classesIds.add(enrollment.Class__c);
    }

    Map<Id, Student__c> students = new Map<Id, Student__c>(
            [SELECT Year_of_Study__c FROM Student__c WHERE Id IN :studentsIds]
    );
    Map<Id, Class__c> classes = new Map<Id, Class__c>(
            [SELECT Year_of_Study__c FROM Class__c WHERE Id IN :classesIds]
    );

    for (Class_Enrollment__c enrollment : newEnrollments) {
      Set<String> classYearsOfStudy = new Set<String>(
              classes.get(enrollment.Class__c).Year_of_Study__c.split(';')
      );

      String studentYearOfStudy = students.get(enrollment.Student__c).Year_of_Study__c;

      if (!classYearsOfStudy.contains(studentYearOfStudy)) {
        enrollment.addError('Student should have same year of study as class');
      }
    }
  }
}
