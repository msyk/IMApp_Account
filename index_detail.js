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
  //IMParts_Catalog.jquery_fileupload.fullUpdate = false;
  const params = INTERMediatorOnPage.getURLParametersAsArray()
  INTERMediator.clearCondition('account_detail')
  if (params['id']) {
    INTERMediator.addCondition('account_detail', {field: 'account_id', operator: '=', value: parseInt(params['id'])})
  }
};

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'
}

function clearFile(aid) {
  if (parseInt(aid) > 0) {
    const context = IMLibContextPool.contextFromName('account_detail')
    context.setDataAtLastRecord('invoice_path', '')
  }
}

function printDetail(aid, kind) {
  if (parseInt(aid) > 0) {
    if (kind == '請求書') {
      open(`invoice.html?id=${aid}`)
    }
  }
}