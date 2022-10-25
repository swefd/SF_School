/**
 * Created by oleksandrchornous on 20/10/22.
 */

public with sharing class TestBundleOptions {
  public ClassOptions classes = new ClassOptions();
  public StudentOptions students = new StudentOptions();
  public ClassEnrollmentOptions classEnrollment = new ClassEnrollmentOptions();

  public class ClassOptions {
    public Integer amount = 1;
    public Integer year = 2020;
    public String yearOfStudy = '1';

    public ClassOptions setAmount(Integer amount) {
      this.amount = amount;
      return this;
    }

    public ClassOptions setYear(Integer year) {
      this.year = year;
      return this;
    }

    public ClassOptions setYearOfStudy(String yearOfStudy) {
      this.yearOfStudy = yearOfStudy;
      return this;
    }

  }

  public class StudentOptions {
    public Integer amount = 1;
    public Integer yearOfStudy = 1;
    public String scholarshipType = Scholarship.UNASSIGNED;

    public StudentOptions setAmount(Integer amount) {
      this.amount = amount;
      return this;
    }

    public StudentOptions setYearOfStudy(Integer yearOfStudy) {
      this.yearOfStudy = yearOfStudy;
      return this;
    }

    public StudentOptions setScholarshipType(String scholarshipType) {
      this.scholarshipType = scholarshipType;
      return this;
    }
  }

  public class ClassEnrollmentOptions {
    public Integer grade = 100;

    public ClassEnrollmentOptions setGrade(Integer grade) {
      this.grade = grade;
      return this;
    }

  }
}