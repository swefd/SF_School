/**
 * Created by oleksandrchornous on 11/10/22.
 */

public with sharing class Utils {
  public static Boolean isValidSalesforceId(String sfdcId) {
    if (sfdcId == null) {
      return false;
    }
    if (
      Pattern.compile('[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}')
        .matcher(sfdcId)
        .matches()
    ) {
      return true;
    }

    return false;
  }
}
