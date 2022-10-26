/**
 * Created by oleksandrchornous on 25/10/22.
 */

import { api, LightningElement, track, wire } from "lwc";
import getRelatedStudents from "@salesforce/apex/StudentController.getRelatedClasses";

export default class RelatedClasses extends LightningElement {
  @api
  recordId;

  @track
  value;

  @track
  options = [];

  @track
  relatedClasses

  @track
  selectedClasses

  @wire(getRelatedStudents, { studentId: "$recordId" })
  pullRelatedClasses({error, data}){
    if (data){
      this.relatedClasses = data;
      this.updatePicklistOptions();
      this.filterSelectedClasses(this.value);
    }else if (error){
      this.error = error
      this.relatedClasses = undefined;
    }
  }


  filterSelectedClasses(year){
    let classesByYear = [];

    for (const relatedClass of this.relatedClasses) {
      if (relatedClass.Year__c === year){
        classesByYear.push(relatedClass);
      }
    }
    this.selectedClasses = classesByYear;
  }

  updatePicklistOptions() {
    let yearToCountMap = new Map()
    const currentYear = new Date().getFullYear();

    for (const class__c of this.relatedClasses) {
      const year = class__c.Year__c;

      if (yearToCountMap.has(year)){
        yearToCountMap.set(year, yearToCountMap.get(year) + 1)
      }else{
        yearToCountMap.set(year, 1)
      }
    }

    let valuesMap = new Map()
    for (let year = currentYear; year > 2000; year--) {
      let optionLabel = ''
      const key = year.toString();
      if (yearToCountMap.has(key)) {
        const classCount = yearToCountMap.get(key)
        optionLabel = `${year} (${classCount})`;
      }else {
        optionLabel = `${year} (none)`
      }
      valuesMap.set(key, {label : optionLabel, value : year.toString()});
    }

    this.options = [...valuesMap.values()]
  }


  connectedCallback() {
    this.value = new Date().getFullYear().toString();

    console.log('Connected ', this.value);
  }

  handleChangeYear(event) {
    this.value = event.detail.value
    console.log(event.detail.value);
    this.filterSelectedClasses(event.detail.value)
  }

}