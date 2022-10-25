/**
 * Created by oleksandrchornous on 23/10/22.
 */

({
  getData: function(cmp) {
    var action = cmp.get("c.getStudentsWithScholarship");
    action.setCallback(this, $A.getCallback(function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var students = response.getReturnValue();

        var icons = {
          "Regular": "utility:dash",
          "Increased": "utility:chevronup",
          "Academic": "utility:jump_to_top"
        };

        students.forEach(function(student) {
          student.linkName = "/" + student.Id;
          student.ScholarshipIcon = icons[student.Scholarship__c];
        });

        cmp.set("v.data", students);
      } else if (state === "ERROR") {
        var errors = response.getError();
        // eslint-disable-next-line no-console
        console.error(errors);
      }
    }));
    $A.enqueueAction(action);
  }
});