<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }
if ($_SERVER['REQUEST_METHOD']	== 'POST') {
   $suffix = '';
    if ($mode === 'update_departament') {
        $departament_id = !empty($_REQUEST['departament_id']) ? $_REQUEST['departament_id'] : 0;
        $data = !empty($_REQUEST['departament_data']) ? $_REQUEST['departament_data'] : [];
        $departament_id = fn_update_departament($data, $departament_id);
        if (!empty($departament_id)) {
            $suffix = ".update_departament?departament_id={$departament_id}";
        } else {
            $suffix = ".add_departament";          
        }        
    } elseif ($mode === 'delete_departament') {
        $departament_id = !empty($_REQUEST['departament_id']) ? $_REQUEST['departament_id'] : 0;
        fn_delete_departament($departament_id);
        $suffix = ".manage";
    } elseif ($mode === 'delete_departaments') {
        foreach ($_REQUEST['departament_ids'] as $v) {
            fn_delete_departament($v);
        }
        $suffix = ".manage";
    } 
    return array(CONTROLLER_STATUS_OK, 'dev_departaments' . $suffix);
}

if ($mode==='manage'){
    list($departaments, $search) = fn_get_departaments($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'), DESCR_SL);
    Tygh::$app['view']->assign('departaments', $departaments);
    Tygh::$app['view']->assign('search', $search);
}elseif($mode==='update_departament' || $mode==='add_departament'){
    $departament_id = !empty($_REQUEST['departament_id']) ? $_REQUEST['departament_id'] : 0;
    $departament_data = fn_get_departament_data($departament_id, DESCR_SL);
    $departament_data['main_pair']['icon']['http_image_path'];
    if (empty($department_data) && $mode === 'update') {
        return [CONTROLLER_STATUS_NO_PAGE];
    }
    Tygh::$app['view']->assign([
        'departament_data' => $departament_data,
        'u_info' => !empty($departament_data['lead_user_id']) ? fn_get_user_short_info($departament_data['lead_user_id']) : [],
    ]);
}