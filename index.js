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
  INTERMediator.lcConditionsOP1AND = false
  INTERMediator.lcConditionsOP2AND = true
  INTERMediator.lcConditionsOP3AND = 'AND'
  const dataSource = INTERMediatorOnPage.getDataSources()
  for (const key in dataSource) {
    if (dataSource[key].name === "account_list" && copyDetail) {
      dataSource[key]["repeat-control"] = "confirm-insert confirm-delete confirm-copy-detail_copy"
    }
  }
  INTERMediatorOnPage.getDataSources = () => {
    return dataSource
  }
};

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById("panelcontent").addEventListener('click', (event) => {
    event.stopPropagation()
  })
  document.getElementById("panelcontent2").addEventListener('click', (event) => {
    event.stopPropagation()
  })
  document.getElementById("option-clear").addEventListener('click', (event) => {
    event.stopPropagation()
  })
  document.getElementById('container').style.display = 'block'
  stickyHeaderTableAdjust()
  INTERMediator.scrollBack(-125 - 157, document.querySelector(".sticky-header-table"))
}

INTERMediatorOnPage.doAfterValueChange = (idValue) => {
  const targetNode = document.getElementById(idValue)
  const targetSpec = targetNode.getAttribute('data-im')
  if (targetSpec.indexOf('preference@copy_detail') === 0) {
    INTERMediator.constructMain();
  }
}

INTERMediatorOnPage.doAfterCreateRecord = (newId, contextName) => {
  if (contextName === 'account_list') {
    INTERMediator.moveAnotherURL(`index_detail.html?id=${newId}`)
  }
}

function clearConditions() {
  IMLibLocalContext.clearAllConditions()
  INTERMediator.clearCondition('account_list')
  INTERMediator.constructMain(IMLibContextPool.contextFromName('account_list'))
}

function exportAccount() {
  INTERMediator.moveAnotherURL('index_contexts.php?media=class://AccountCSV/account_all')
}

function moveDetailPage(aid) {
  aid = parseInt(aid)
  INTERMediator.prepareToScrollBack('account_list', aid)
  INTERMediator.moveAnotherURL(`index_detail.html?id=${aid}`)
}

function setCondition(n) {
  if (parseInt(n) > 0 && parseInt(n) < 3) {
    const y = (new Date()).getFullYear() - parseInt(n) + 1
    IMLibLocalContext.setValue('condition:account_list:issued_date:>=', `${y}-01-01`)
    IMLibLocalContext.setValue('condition:account_list:issued_date:<=', `${y}-12-31`)
    INTERMediator.constructMain()
  } else if (parseInt(n) === 3) {
    const start = new Date()
    start.setMonth(start.getMonth() - 2)
    start.setDate(1)
    start.setHours(start.getHours() + 9)
    const end = new Date()
    end.setMonth(end.getMonth() + 2)
    end.setDate(0)
    end.setHours(end.getHours() + 9)
    IMLibLocalContext.setValue('condition:account_list:issued_date:>=', start.toISOString().substring(0, 10))
    IMLibLocalContext.setValue('condition:account_list:issued_date:<=', end.toISOString().substring(0, 10))
    INTERMediator.constructMain()
  }
}

function showPanel() {
  document.getElementById('funcpanel').style.display = 'block'
}

function hidePanel() {
  document.getElementById('funcpanel').style.display = 'none'
}

function showPanel2() {
  document.getElementById('funcpanel2').style.display = 'block'
}

function hidePanel2() {
  document.getElementById('funcpanel2').style.display = 'none'
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

function csvReadRakuten() {
  csvReadBankImpl(20000, 1, 1, 3, 1)
}

let accountId = -1

function csvReadBankImpl(dateCol, outCol, inCol, descCol, skipLine) {
  if (!(dateCol >= 0) || !(outCol >= 0) || !(inCol >= 0) || !(descCol >= 0) || !(skipLine >= 0)) {
    console.log('why!?')
    return
  }
  let is8DigitDate = false
  let isSepDate = false
  if (dateCol > 19999) {
    is8DigitDate = true
    dateCol = dateCol % 20000
  } else if (dateCol > 9999) {
    isSepDate = true
    dateCol = dateCol % 10000
  }
  const src = document.getElementById('csv_data').value
  var srcTemp = src
  if (src.indexOf("\"") !== -1) {
    srcTemp = src.replace(/\"/g, "")
  }
  const lines = srcTemp.split('\n')
  let count = 0
  for (const line of lines) {
    const items = line.split(',')
    if (count >= skipLine && items.length > 3) {
      let dateComps
      if (is8DigitDate) {
        dateComps = [items[dateCol].substring(0, 4), items[dateCol].substring(4, 6), items[dateCol].substring(6, 8)]
      } else if (isSepDate) {
        dateComps = [items[dateCol], items[dateCol + 1], items[dateCol + 2]]
      } else {
        if (items[dateCol].indexOf('/') > 0) {
          dateComps = items[dateCol].split('/')
        } else if (items[dateCol].indexOf('.') > 0) {
          dateComps = items[dateCol].split('.')
        }
        if (items[dateCol].indexOf('-') > 0) {
          dateComps = items[dateCol].split('-')
        }
      }
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
          {field: 'unit_price', value: Math.abs(outCol === inCol ? items[outCol] : items[outCol] + items[inCol])},
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

function uiIdSearch(id) {
  id = parseInt(id)
  if (id > 0) {
    INTERMediator.clearCondition('account_list')
    IMLibLocalContext.clearAllConditions()
    IMLibLocalContext.setValue('condition:account_list:account_id,parent_account_id:=', id)
    INTERMediator.constructMain(IMLibContextPool.contextFromName('account_list'))
  }
}

function codeSearch(debit, credit, mode = null) {
  hidePanel2()
  if (document.getElementById("option-clear").checked) {
    IMLibLocalContext.clearAllConditions()
  }
  INTERMediator.clearCondition('account_list')
  if (debit) {
    INTERMediator.addCondition('account_list', {field: 'debit_id', value: debit})
  }
  if (credit) {
    INTERMediator.addCondition('account_list', {field: 'credit_id', value: credit})
  }
  if (mode === "typeA") {
    INTERMediator.addCondition('account_list', {field: 'parent_account_id', operator: "IS NULL"})
  }
  if (mode === "typeB") {
    INTERMediator.addCondition('account_list', {field: 'parent_account_id', operator: "IS NOT NULL"})
  }
  if (mode === "typeC") {
    INTERMediator.addCondition('account_list', {field: 'item_total', operator: "<>", value: "@parent_total@"})
  }
  INTERMediator.constructMain(IMLibContextPool.contextFromName('account_list'))

}