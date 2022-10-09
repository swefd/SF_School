/**
 * Created by oleksandrchornous on 09/10/22.
 */

public with sharing class Utils {
  public static Decimal calculateAverage(List<Decimal> decimals) {
    Decimal sum = 0;
    for (Decimal dec : decimals) {
      sum += dec;
    }

    return sum / decimals.size();
  }
}
