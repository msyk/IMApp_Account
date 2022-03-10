/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt
 */
INTERMediatorOnPage.doBeforeConstruct = function () {
  INTERMediatorLog.suppressDebugMessageOnPage = true;
  INTERMediatorOnPage.buttonClassCopy = "btn btn-info"
  INTERMediatorOnPage.buttonClassDelete = "btn btn-info"
  INTERMediatorOnPage.buttonClassInsert = "btn btn-info"
  INTERMediatorOnPage.buttonClassMaster = "btn btn-info"
  INTERMediatorOnPage.buttonClassBackNavi = "btn btn-info"
};

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'
}

function clearConditions() {
  IMLibLocalContext.setValue('condition:account_list:account_id:=','')
  IMLibLocalContext.setValue('condition:account_list:issued_date:>=','')
  IMLibLocalContext.setValue('condition:account_list:issued_date:<=','')
  IMLibLocalContext.setValue('condition:account_list:company:*match*','')
  IMLibLocalContext.setValue('condition:account_list:item_total:>=','')
  IMLibLocalContext.setValue('condition:account_list:item_total:<=','')
  INTERMediator.constructMain(IMLibContextPool.contextFromName('account_list'))
}