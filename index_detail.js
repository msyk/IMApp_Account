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

function backToList() {
  IMLibQueue.setTask((complete) => {
    complete()
    location.href = "index.html"
  }, false, true)
}

function clearFile(aid) {
  if (parseInt(aid) > 0) {
    const context = IMLibContextPool.contextFromName('account_detail')
    context.setDataAtLastRecord('invoice_path', '')
    IMLibQueue.setTask((complete) => {
      complete()
      INTERMediator.constructMain()
    }, false, true)
  }
}

function printDetail(aid) {
  const context = IMLibContextPool.contextFromName('account_detail')
  const kind = context.getDataAtLastRecord('title')
  if (parseInt(aid) > 0) {
    if (kind == '請求書') {
      open(`invoice.html?id=${aid}`)
    } else if (kind == '見積書') {
      open(`estimate.html?id=${aid}`)
    } else if (kind == '領収書') {
      open(`receipt.html?id=${aid}`)
    } else {
      alert(`${kind}はまだ実装していません。`)
    }
  }
}

function csvReadSAISON() {
  csvReadImpl(5)
}

function csvReadVpass() {
  csvReadImpl(2)
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

let accountId = null

function generateDetailToAccount() {
  const pcontext = IMLibContextPool.contextFromName('account_detail')
  const parentId = pcontext.getDataAtLastRecord('account_id')
  const context = IMLibContextPool.contextFromName('detail_list')
  let counter = 0
  for (const key in context.store) {
    accountId = null
    if (context.store[key].description.indexOf(',') >= 0 && context.store[key].qty == 1) {
      const itemDate = context.store[key].description.split(',')[0].trim().replaceAll('/', '-')
      const itemDesc = context.store[key].description.split(',')[1].trim()
      const up = context.store[key].unit_price
      IMLibQueue.setTask((complete) => {
        const data = [
          {field: 'description', value: itemDesc},
          {field: 'issued_date', value: itemDate},
          {field: 'parent_account_id', value: parentId},
          {field: 'assort_pattern_id', value: 7},
          {field: 'debit_id', value: 2},
          {field: 'credit_id', value: 405},
          {field: 'company', value: itemDesc}
        ]
        INTERMediator_DBAdapter.db_createRecord_async({name: 'account_add', dataset: data}, (result) => {
          accountId = result.dbresult[0]['account_id']
          counter += 1
          INTERMediatorLog.flushMessage()
          complete()
        }, () => {
          INTERMediatorLog.flushMessage()
          complete()
        })
      })
      IMLibQueue.setTask((complete) => {
        if (!(parseInt(accountId) > 0)) {
          complete()
          return
        }
        const data = [
          {field: 'account_id', value: accountId},
          {field: 'description', value: itemDesc},
          {field: 'unit_price', value: parseInt(up)},
          {field: 'qty', value: 1}
        ]
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
    alert(`${counter}件の会計項目を新たに作りました。`)
    complete()
  })
}