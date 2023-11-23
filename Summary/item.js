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
  INTERMediator.alwaysAddOperationExchange = true;
  INTERMediatorLog.suppressDebugMessageOnPage = true;
  INTERMediatorOnPage.buttonClassCopy = "btn btn-info"
  INTERMediatorOnPage.buttonClassDelete = "btn btn-warning"
  INTERMediatorOnPage.buttonClassInsert = "btn btn-success"
  INTERMediatorOnPage.buttonClassMaster = "btn btn-primary"
  INTERMediatorOnPage.buttonClassBackNavi = "btn btn-primary"
};

let year = null;

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'

  const context = IMLibContextPool.contextFromName('year_detail')
  if (context) {
    year = context.getDataAtLastRecord('year')
  }
  const params = INTERMediatorOnPage.getURLParametersAsArray()
  INTERMediator.clearCondition('year_detail_single')
  INTERMediator.clearCondition('item_debit')
  INTERMediator.clearCondition('account_debit')
  INTERMediator.clearCondition('item_credit')
  INTERMediator.clearCondition('account_credit')
  if (params['year']) {
    INTERMediator.addCondition('year_detail_single', {field: 'year', operator: '=', value: parseInt(params['year'])})
  }
}

function showMoreDetail(type, id) {
  INTERMediator.moveAnotherURL(`/Summary/item_detail.html?year=${year}&${type}=${id}`)
}