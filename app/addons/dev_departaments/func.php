<?php
use Tygh\Languages\Languages;
use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

function fn_get_departaments($params = array(), $items_per_page, $lang_code = CART_LANGUAGE)
{
    $default_params = array(
        'page' => 1,
        'items_per_page' => 3
    );
    $params = array_merge($default_params, $params);
    if (AREA == 'C') {
        $params['status'] = 'A';
    }
    $sortings = array(
        'timestamp' => '?:departaments.timestamp',
        'name' => '?:departaments_descriptions.departament',
        'status' => '?:departaments.status',
    );
    $condition = $limit = $join = '';
    if (!empty($params['limit'])) {
        $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
    }
    $sorting = db_sort($params, $sortings, 'name', 'asc');
    if (!empty($params['item_ids'])) {
        $condition .= db_quote(' AND ?:departaments.departament_id IN (?n)', explode(',', $params['item_ids']));
    }
    if (!empty($params['departament_id'])) {
        $condition .= db_quote(' AND ?:departaments.departament_id = ?i', $params['departament_id']);
    }
    if (!empty($params['status'])) {
        $condition .= db_quote(' AND ?:departaments.status = ?s', $params['status']);
    }
    if (!empty($params['departaments'])) {
        $condition .= db_quote(' AND ?:departaments_descriptions.departament = ?s', $params['departaments']);
    }
    $fields = array (
        '?:departaments.departament_id',
        '?:departaments.status',
        '?:departaments.timestamp',
        '?:departaments.lead_user_id',
        '?:departaments_descriptions.departament',
        '?:departaments_descriptions.description',
    );
    $join .= db_quote(' LEFT JOIN ?:departaments_descriptions ON ?:departaments_descriptions.departament_id = ?:departaments.departament_id AND ?:departaments_descriptions.lang_code = ?s', $lang_code);
    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:departaments $join WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }
    $departaments = db_get_hash_array(
        "SELECT ?p FROM ?:departaments " .
        $join .
        "WHERE 1 ?p ?p ?p",
        'departament_id', implode(', ', $fields), $condition, $sorting, $limit
    );
    $departament_image_ids = array_keys($departaments);
    $images = fn_get_image_pairs($departament_image_ids, 'departament', 'M', true, false, $lang_code);
    foreach ($departaments as $departament_id => $departament) {
        $departaments[$departament_id]['main_pair'] = !empty($images[$departament_id]) ? reset($images[$departament_id]) : array();
    }
    foreach ($departaments as $departament_id => $departament) {
        $user_info = fn_get_user_info($departament['lead_user_id'], false);
        $departaments[$departament_id]['user_info'] = $user_info;
    }
    $cache_key = "departaments";
    $cache_tables = ['departaments'];
    Registry::registerCache(
        $cache_key,
        $cache_tables,
        Registry::cacheLevel('static')
    );   
    Registry::set($cache_key, $departaments);
    $departaments = Registry::get($cache_key, $departaments);
    return array($departaments, $params);
}

function fn_update_departament($data, $departament_id, $lang_code = DESCR_SL){
  
    if (isset($data['timestamp'])) {
        $data['timestamp'] = fn_parse_date($data['timestamp']);
    }
    
    if (!empty($departament_id)) {
        db_query("UPDATE ?:departaments SET ?u WHERE departament_id = ?i", $data, $departament_id);
        db_query("UPDATE ?:departaments_descriptions SET ?u WHERE departament_id = ?i AND lang_code = ?s", $data, $departament_id, $lang_code);
    } else {
        $departament_id = $data['departament_id'] = db_replace_into ('departaments', $data);

        foreach (Languages::getAll() as $data['lang_code'] => $v) {
            db_query("REPLACE INTO ?:departaments_descriptions ?e", $data);
        } 
    }
    if (!empty($departament_id)) {
        fn_attach_image_pairs ('departament','departament', $departament_id, $lang_code);

    }
    $worker_id = !empty ($data['workers_ids']) ? $data['workers_ids'] : [];
    $worker_ids = explode(",", $worker_id);
    fn_departament_add_links($departament_id, $worker_ids);

    return $departament_id;
}

function fn_departament_add_links($departament_id, $worker_ids)
{
    if (!empty($worker_ids)) {
        foreach ($worker_ids as $worker_id) {
            db_query("REPLACE INTO ?:departaments_links ?e", [
                'worker_id' => $worker_id,
                'departament_id' => $departament_id,
            ]);
            
        }
    }
}

function fn_delete_departament($departament_id){
    if (!empty($departament_id)){
        db_query("DELETE FROM ?:departaments WHERE departament_id = ?i", $departament_id);
        db_query("DELETE FROM ?:departaments_links WHERE departament_id = ?i", $departament_id);
        db_query("DELETE FROM ?:departaments_descriptions WHERE departament_id = ?i", $departament_id);
    }
}


function fn_get_departament_data ($departament_id = 0, $lang_code = CART_LANGUAGE)
{
    $departament = [];
    if (!empty($departament_id)){
        list($departament) = fn_get_departaments([
            'departament_id' => $departament_id
        ], 1, $lang_code);
        if (!empty($departament)) {
            $departament = reset($departament);
            $departament['worker_ids'] = fn_departament_get_links($departament_id);
            foreach ($departament['worker_ids'] as $worker =>$worker_id) {
                $departament['workers'][] = fn_get_user_info($worker_id, false);
            }
       }
    }
    return $departament;
}
function fn_departament_get_links($departament_id)
{
    return !empty($departament_id) ? db_get_fields('SELECT worker_id from `?:departaments_links` WHERE  `departament_id` = ?i', $departament_id) : [];
}




