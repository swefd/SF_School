/**
 * Created by oleksandrchornous on 18/10/22.
 */

trigger ClassEnrollmentTrigger on Class_Enrollment__c(
        before insert,
        before update
) {

  if (Trigger.isBefore) {
    ClassEnrollmentTriggerHandler.checkBulkDuplicates(Trigger.new);

    if (Trigger.isInsert) {
      ClassEnrollmentTriggerHandler.checkExistsDuplicates(Trigger.new);
      ClassEnrollmentTriggerHandler.checkYearOfStudy(Trigger.new);
    } else if (Trigger.isUpdate) {
      ClassEnrollmentTriggerHandler.checkExistsDuplicatesOnUpdate(Trigger.oldMap, Trigger.new);
      //ClassEnrollmentTriggerHandler.checkYearOfStudy(Trigger.new);
    }
  }

}
