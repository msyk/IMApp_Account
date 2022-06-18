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
  INTERMediatorOnPage.buttonClassMaster = "btn btn-secondary"
  INTERMediatorOnPage.buttonClassBackNavi = "btn btn-secondary"
};

INTERMediatorOnPage.doAfterConstruct = function () {
  document.getElementById('container').style.display = 'block'
}

function clearConditions() {
  IMLibLocalContext.clearAllConditions()
  INTERMediator.constructMain(IMLibContextPool.contextFromName('account_list'))
}

function setCondition(n) {
  if (parseInt(n) > 0 && parseInt(n) < 3) {
    const y = (new Date()).getFullYear() - parseInt(n) + 1
    IMLibLocalContext.setValue('condition:account_list:issued_date:>=', `${y}-01-01`)
    IMLibLocalContext.setValue('condition:account_list:issued_date:<=', `${y}-12-31`)
    INTERMediator.constructMain()
  } else if (parseInt(n) == 3) {
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
