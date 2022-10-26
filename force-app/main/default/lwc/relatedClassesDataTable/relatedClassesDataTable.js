/**
 * Created by oleksandrchornous on 25/10/22.
 */

import { api, LightningElement} from "lwc";

const columns = [
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Subject", fieldName: "Subject__c", type: "text" },
  { label: "Year", fieldName: "Year__c", type: "text" }
];

export default class RelatedClassesDataTable extends LightningElement {
  error;
  columns = columns;

  @api
  classesList

  // dispatchYears(data) {
  //   let mapOfYears = new Map()
  //   for (const class__c of data) {
  //     if (!mapOfYears.has(class__c.Year__c)){
  //       mapOfYears.set(class__c.Year__c, {label : class__c.Year__c, value : class__c.Year__c})
  //     }
  //   }
  //   this.dispatchEvent(new CustomEvent("dataloaded", {
  //     detail: [...mapOfYears.values()]
  //   }));
  // }

}