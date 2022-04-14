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

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'
}

INTERMediatorOnPage.doAfterCreateRecord = (newId, contextName) => {
  if (contextName == 'account_list') {
    /*
    const data = [
      {field: 'unit_price', value: 0},
      {field: 'qty', value: 1},
      {field: 'account_id', value: newId}
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
     */
    IMLibQueue.setTask((complete) => {
      complete()
      location.href = `index_detail.html?id=${newId}`
    }, false, true)
  }
}

function clearConditions() {
  IMLibLocalContext.clearAllConditions()
  INTERMediator.constructMain(IMLibContextPool.contextFromName('account_list'))
}

function exportAccount() {
  location.href = 'index_contexts.php?media=class://AccountCSV/account_all'
}

function setCondition(n) {
  if (parseInt(n) > 0 && parseInt(n) < 3) {
    const y = (new Date()).getFullYear() - parseInt(n) + 1
    IMLibLocalContext.setValue('condition:account_list:issued_date:>=', `${y}-01-01`)
    IMLibLocalContext.setValue('condition:account_list:issued_date:<=', `${y}-12-31`)
    INTERMediator.constructMain()
  }
}

function showPanel() {
  document.getElementById('funcpanel').style.display = 'block'
}

function hidePanel() {
  document.getElementById('funcpanel').style.display = 'none'
}

function csvReadSMBC() {
  csvReadBankImpl(0, 1, 2, 3, 1)
}

function csvReadMuzuho() {
  csvReadBankImpl(1, 2, 3, 4, 10)
}

function csvReadPayPay() {
  csvReadBankImpl(10000, 8, 9, 7, 1)
}

let accountId = -1

function csvReadBankImpl(dateCol, outCol, inCol, descCol, skipLine) {
  if (!(dateCol >= 0) || !(outCol >= 0) || !(inCol >= 0) || !(descCol >= 0) || !(skipLine >= 0)) {
    console.log('why!?')
    return
  }
  let isSepDate = false
  if (dateCol > 9999) {
    isSepDate = true
    dateCol = dateCol % 10000
  }
  const src = document.getElementById('csv_data').value
  var srcTemp = src
  if (src.indexOf("\"") != -1) {
    srcTemp = src.replace(/\"/g, "")
  }
  const lines = srcTemp.split('\n')
  let count = 0
  for (const line of lines) {
    const items = line.split(',')
    if (count >= skipLine && items.length > 4) {
      const dateComps = (isSepDate
        ? `${items[dateCol]}/${items[dateCol + 1]}/${items[dateCol + 2]}`
        : items[dateCol]).split('/')
      dateComps[1] = `0${dateComps[1]}`
      dateComps[2] = `0${dateComps[2]}`
      const dateValue = dateComps[0] + "-" + dateComps[1].substring(dateComps[1].length - 2)
        + "-" + dateComps[2].substring(dateComps[2].length - 2)
      IMLibQueue.setTask((complete) => {
        const data = [
          {field: 'description', value: items[descCol]},
          {field: 'issued_date', value: dateValue},
          {field: 'assort_pattern_id', value: ""},
          {field: 'debit_id', value: (items[inCol] > 0) ? 115 : 2},
          {field: 'credit_id', value: (items[inCol] > 0) ? 2 : 115},
          {field: 'company', value: items[descCol]}
        ]
        INTERMediator_DBAdapter.db_createRecord_async({name: 'account_add', dataset: data}, (result) => {
          accountId = result.dbresult[0]['account_id']
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
          {field: 'description', value: items[descCol]},
          {field: 'unit_price', value: Math.abs(items[outCol] + items[inCol])},
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
    count += 1
  }
  IMLibQueue.setTask((complete) => {
    complete()
    INTERMediator.constructMain()
  })
}

