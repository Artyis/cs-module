<?php
use Tygh\Registry;


if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode === 'departaments') {
    Tygh::$app['session']['continue_url'] = "dev_departaments.departaments";
    $params = $_REQUEST;
    list($departaments, $search) = fn_get_departaments($params, Registry::get('settings.Appearance.products_per_page'), CART_LANGUAGE);
    Tygh::$app['view']->assign('departaments', $departaments);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('columns', 3);

    fn_add_breadcrumb(__('departaments'));


} elseif ($mode === 'departament') {
    $departament_data = [];
    $departament_id = !empty($_REQUEST['departament_id']) ? $_REQUEST['departament_id'] : 0;
    $departament_data = fn_get_departament_data($departament_id, CART_LANGUAGE);
    
    if (empty($departament_data)) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }
    
    Tygh::$app['view']->assign('departament_data', $departament_data);
    Tygh::$app['view']->assign('user_info', $user_info);

    fn_add_breadcrumb(__('departaments'), "dev_departaments.departaments");
    }