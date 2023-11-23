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
  INTERMediatorOnPage.buttonClassDelete = "btn btn-warning"
  INTERMediatorOnPage.buttonClassInsert = "btn btn-success"
  INTERMediatorOnPage.buttonClassMaster = "btn btn-primary"
  INTERMediatorOnPage.buttonClassBackNavi = "btn btn-primary"

  const params = INTERMediatorOnPage.getURLParametersAsArray()
  INTERMediator.clearCondition('year_detail_single')
  INTERMediator.clearCondition('item_debit')
  INTERMediator.clearCondition('account_debit')
  INTERMediator.clearCondition('item_credit')
  INTERMediator.clearCondition('account_credit')
  if (params['year']) {
    INTERMediator.addCondition('year_detail_single', {field: 'year', operator: '=', value: parseInt(params['year'])})
  }
  if (params['debit']) {
    INTERMediator.addCondition('item_debit', {field: 'debit_id', operator: '=', value: parseInt(params['debit'])})
    INTERMediator.addCondition('account_debit', {field: 'debit_id', operator: '=', value: parseInt(params['debit'])})
    INTERMediator.addCondition('item_credit', {field: 'credit_id', operator: '=', value: -1})
    INTERMediator.addCondition('account_credit', {field: 'credit_id', operator: '=', value: -1})
  }
  if (params['credit']) {
    INTERMediator.addCondition('item_debit', {field: 'debit_id', operator: '=', value: -1})
    INTERMediator.addCondition('account_debit', {field: 'debit_id', operator: '=', value: -1})
    INTERMediator.addCondition('item_credit', {field: 'credit_id', operator: '=', value: parseInt(params['credit'])})
    INTERMediator.addCondition('account_credit', {field: 'credit_id', operator: '=', value: parseInt(params['credit'])})
  }
};

let year = null

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'

  const context = IMLibContextPool.contextFromName('year_detail_single')
  if (context) {
    year = context.getDataAtLastRecord('year')
  }
}

function backToAllSummary() {
  INTERMediator.moveAnotherURL(`/Summary/item.html?year=${year}`)
}

function moveAccountItem(id) {
  const myURL = encodeURIComponent(location.href)
  INTERMediator.moveAnotherURL(`/index_detail.html?id=${id}&back=${myURL}`)
}