INTERMediatorOnPage.doBeforeConstruct = function () {
  INTERMediator.alwaysAddOperationExchange = true;
  INTERMediatorLog.suppressDebugMessageOnPage = true;
  INTERMediatorOnPage.buttonClassCopy = "btn btn-info"
  INTERMediatorOnPage.buttonClassDelete = "btn btn-warning"
  INTERMediatorOnPage.buttonClassInsert = "btn btn-success"
  INTERMediatorOnPage.buttonClassMaster = "btn btn-primary"
  INTERMediatorOnPage.buttonClassBackNavi = "btn btn-primary"

  const params = INTERMediatorOnPage.getURLParametersAsArray()
  if (params['ym']) {
    INTERMediator.clearCondition('monthly_detail')
    INTERMediator.addCondition('monthly_detail', {field: 'ym', operator: '=', value: params['ym']})
    INTERMediator.clearCondition('account_income')
    INTERMediator.addCondition('account_income', {field: 'ym', operator: '=', value: params['ym']})
    INTERMediator.clearCondition('account_purchase')
    INTERMediator.addCondition('account_purchase', {field: 'ym', operator: '=', value: params['ym']})
    INTERMediator.clearCondition('account_others')
    INTERMediator.addCondition('account_others', {field: 'ym', operator: '=', value: params['ym']})
  }

};

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'
}

function moveAccountItem(id) {
  const myURL = encodeURIComponent(location.href)
  INTERMediator.moveAnotherURL(`/index_detail.html?id=${id}&back=${myURL}`)
}