/**
 * Created by oleksandrchornous on 23/10/22.
 */

({
  init: function(cmp, event, helper) {
    cmp.set("v.columns", [
      {
        label: "Student Name", fieldName: "linkName", type: "url",
        typeAttributes: { label: { fieldName: "Name" }, target: "_blank" }
      },

      {
        label: "Scholarship", fieldName: "Scholarship__c", type: "text",
        cellAttributes: {
          iconName: { fieldName: "ScholarshipIcon" },
          iconPosition: "left"
        }
      },
      { label: "Average Grade", fieldName: "Average_Grade__c", type: "number" }
    ]);
    helper.getData(cmp);
  }

});