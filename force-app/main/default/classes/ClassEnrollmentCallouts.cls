/**
 * Created by oleksandrchornous on 30/10/22.
 */

public with sharing class ClassEnrollmentCallouts {
  public static final String URL = 'https://avenga-school.herokuapp.com';

  public static HttpResponse remove(String recordId) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(URL + '/delete-record');
    request.setMethod('DELETE');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setHeader('recordId', recordId);
    HttpResponse response = http.send(request);
    // Parse the JSON response
    if(response.getStatusCode() == 200) {
      System.debug('response : ' +
              response.getStatusCode() + ' ' + response.getStatus());
    } else {
      System.debug(response.getBody());
    }
    return response;
  }

}