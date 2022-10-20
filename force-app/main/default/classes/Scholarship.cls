/**
 * Created by oleksandrchornous on 16/10/22.
 */

public with sharing class Scholarship {
  public final static List<String> typesList = new List<String>{
          'Unassigned',
          'Regular',
          'Increased',
          'Academic'
  };

  public final static String UNASSIGNED = 'Unassigned';
  public final static String REGULAR = 'Regular';
  public final static String INCREASED = 'Increased';
  public final static String ACADEMIC = 'Academic';

  public final static Decimal REGULAR_MIN_GRADE = 71;
  public final static Decimal REGULAR_THRESHOLD_GRADE = 87;
}
