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
  const params = INTERMediatorOnPage.getURLParametersAsArray()
  INTERMediator.clearCondition('account_detail')
  if (params['id']) {
    INTERMediator.addCondition('account_detail', {field: 'account_id', operator: '=', value: parseInt(params['id'])})
  }
};

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'

  const context = IMLibContextPool.contextFromName('account_detail')
  const aid = context.getDataAtLastRecord('account_id')
  const title = context.getDataAtLastRecord('title')
  const nameTable = {請求書: 'invoice', 見積書: 'estimate', 領収書: 'receipt'}
  document.title = `${nameTable[title]}-${aid}`
}
