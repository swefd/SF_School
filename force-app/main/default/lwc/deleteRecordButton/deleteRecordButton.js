/**
 * Created by oleksandrchornous on 29/10/22.
 */

import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import removeRecord from '@salesforce/apex/ClassEnrollmentIntegration.remove'
import LightningConfirm from 'lightning/confirm';
// import { NavigationMixin } from 'lightning/navigation';

const toastMessage = {
  success: {
    variant: 'success',
    message: 'Record deleted successfully',
  },
  failed: {
    variant: 'success',
    message: 'Record delete was failed',
  },
};

export default class DeleteRecordButton extends LightningElement {

  @api
  recordId;

  @api tabName;

  async handleClick() {
    const deleteConfirmed = await this.showConfirmModal();

    if (deleteConfirmed){
      removeRecord({ 'recordId': this.recordId }).then(res => {
        if (res) {
          this.showDeleteToast(toastMessage.success.variant, toastMessage.success.message);
          // eslint-disable-next-line @lwc/lwc/no-async-operation
          setTimeout(this.navigateToTabPage, 2000);
        } else {
          this.showDeleteToast(toastMessage.failed.variant, toastMessage.failed.message);
        }
      })
    }
  }

  async showConfirmModal(){
    return LightningConfirm.open({
      message: "Are you sure you want to delete this record?",
      variant: "default", // headerless
      label: "Delete a record",
      theme: 'warning'
    });
  }

  showDeleteToast(variant, message) {
    const event = new ShowToastEvent({
      title: 'Delete record',
      message: message,
      variant: variant,
      mode: 'dismissable',
    });
    this.dispatchEvent(event);
  }

  navigateToTabPage() {
    window.location.assign('https://avenga-31c-dev-ed.lightning.force.com/lightning/o/Class_Enrollment__c/home')

    // this[NavigationMixin.Navigate]({
    //   type: 'standard__navItemPage',
    //   attributes: {
    //     // CustomTabs from managed packages are identified by their
    //     // namespace prefix followed by two underscores followed by the
    //     // developer name. E.g. 'namespace__TabName'
    //     apiName: 'Class_Enrollments'
    //   }
    // });

  }
}