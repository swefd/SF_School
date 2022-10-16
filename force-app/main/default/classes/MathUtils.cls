/**
 * Created by oleksandrchornous on 09/10/22.
 */

public with sharing class MathUtils {
  public static Decimal calculateAverage(List<Decimal> decimals) {
    if (decimals == null || decimals.isEmpty()) {
      throw new IllegalArgumentException('List should be not empty or null');
    }

    Decimal sum = 0;
    for (Decimal dec : decimals) {
      sum += dec;
    }

    return sum / decimals.size();
  }
}
