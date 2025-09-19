
using { pocap.db.master as master, pocap.db.transaction as transaction  } from '../db/datamodel';
using { pocap.common as common } from '../db/common';




service CatalogService @(path: 'CatalogService')
{

@Capabilities : {
    
    InsertRestrictions : {
        $Type : 'Capabilities.InsertRestrictionsType',
        Insertable : true }, 
    
    UpdateRestrictions : {
        $Type : 'Capabilities.UpdateRestrictionsType',
        Updatable: true        
    },

    DeleteRestrictions : {
        $Type : 'Capabilities.DeleteRestrictionsType',
        Deletable : true
    },

}    
entity BusinessPartners as projection on master.businesspartner;
entity productionInformation as projection on master.product;
//@readonly
//entity EmpployeeDetails as projection on master.employees;
//entity AddressInfo as projection on master.address;

 entity EmployeeDetails @(restrict: [
    {
      grant : ['READ'], to : 'Viewer', where : 'bankName = $user.bankName'
    },
    {
      grant : ['WRITE'], to : 'Admin'
    }
  ]) as projection on master.employees;

  entity AddressInfo @(restrict: [
    {
      grant : ['READ'], to : 'Viewer', where : 'COUNTRY = $user.myCountry'
    },
    {
      grant : ['WRITE'], to : 'Admin'
    }
  ]) as projection on master.address;





entity PODetails @( odata.draft.enabled : true )  as projection on transaction.purchaseorder{
    *,
    case OVERALL_STATUS
        when 'N' then 'New'
        when 'P' then 'Piad'
        when 'B' then 'Blocked'
        when 'R' then 'Return'
        else 'Delivered'
        end as overallStatus : String(20) @(title: '{i18n>OVERALL_STATUS}'), 
    case OVERALL_STATUS
        when 'N' then 1
        when 'P' then 2
        when 'B' then 3
        when 'R' then 1
        else 3
        end as OScriticality : Integer,

    case LIFECYCLE_STATUS
        when 'N' then 'New'
        when 'I' then 'In Process'
        when 'P' then 'Pending'
        when 'C' then 'Cancelled'
        else 'Delivered'
        end as LIFECYCLESTATUS : String(20) @(title: '{i18n>LIFECYCLE_STATUS}'), 
    case LIFECYCLE_STATUS
        when 'N' then 3
        when 'P' then 2
        when 'B' then 1
        when 'R' then 1
        else 2
        end as LScriticality : Integer,        

    Items:  redirected to POItems
}

actions{
    @cds.odata.bindingparameter.name : '_pricehike'
    @Common.SideEffects : {
        TargetProperties : [
            '_pricehike/GROSS_AMOUNT'
        ],
    }
    action increasedPrice() returns array of PODetails;
    function largestOrder() returns array of PODetails;
};
entity POItems as projection on transaction.purchaseitems;


action createEmployee(
// Import Parameters
    nameFirst    : String(40),
    nameMiddle   : String(40),
    nameLast     : String(40),
    nameInitials : String(40),
    gender       : common.Gender,
    language     : String(2),
    phone        : common.phoneNumber,
    email        : common.Email,
    loginName    : String(15),
    salaryAmount : common.AmountT,
    accountNumber: String(16),
    bankId       : String(12),
    bankName     : String(64)
)
// Export Parameters
returns array of String;


function getProducts(CurrencyCode : String(3)) returns productionInformation;

}
