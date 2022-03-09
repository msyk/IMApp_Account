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

function printDetail(aid) {
  const context = IMLibContextPool.contextFromName('account_detail')
  const kind = context.getDataAtLastRecord('title')
  if (parseInt(aid) > 0) {
    if (kind == '請求書') {
      open(`invoice.html?id=${aid}`)
    } else {
      alert(`${kind}はまだ実装していません。`)
    }
  }
}

function csvReadSAISON() {
  csvReadImpl(5)
}

function csvReadVpass() {
  csvReadImpl(6)
}

function csvReadImpl(pCol) {
  if (!(pCol > 0)) {
    console.log('why!?')
    return
  }
  const context = IMLibContextPool.contextFromName('account_detail')
  const fvalue = context.getDataAtLastRecord('account_id')
  const src = document.getElementById('csv_data').value
  const lines = src.split('\n')
  for (const line of lines) {
    const items = line.split(',')
    if (parseInt(items[pCol]) > 0) {
      const data = [
        {field: 'description', value: items[0] + ',' + items[1]},
        {field: 'unit_price', value: parseInt(items[pCol])},
        {field: 'qty', value: 1},
        {field: 'account_id', value: fvalue}
      ]
      IMLibQueue.setTask((complete) => {
        INTERMediator_DBAdapter.db_createRecord_async({name: 'detail_add', dataset: data}, (result) => {
          INTERMediatorLog.flushMessage()
          complete()
        }, () => {
          INTERMediatorLog.flushMessage()
          complete()
        })
      })
    }
  }
  IMLibQueue.setTask((complete) => {
    complete()
    INTERMediator.constructMain()
  })
}

function generateDetailToAccount() {

}