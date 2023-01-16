{capture name="mainbox"}

<form action="{""|fn_url}" method="post" id="dev_departaments_form" name="dev_departaments_form" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />
{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id="pagination_contents_dev_departaments"}

{$c_url=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

{$rev=$smarty.request.content_id|default:"pagination_contents_dev_departaments"}
{include_ext file="common/icon.tpl" class="icon-`$search.sort_order_rev`" assign=c_icon}
{include_ext file="common/icon.tpl" class="icon-dummy" assign=c_dummy}
{$departament_statuses=""|fn_get_default_statuses:true}
{$has_permission = fn_check_permissions("departament", "update_status", "admin", "POST")}
{if $departaments}
    {capture name="dev_departaments_table"}
        <div class="table-responsive-wrapper longtap-selection">
            <table class="table table-middle table--relative table-responsive">
            <thead
                data-ca-bulkedit-default-object="true"
                data-ca-bulkedit-component="defaultObject"
            >
            <tr>
                <th width="6%" class="left mobile-hide">
                    {include file="common/check_items.tpl" is_check_disabled=!$has_permission check_statuses=($has_permission) ? $departament_statuses : '' }

                    <input type="checkbox"
                        class="bulkedit-toggler hide"
                        data-ca-bulkedit-disable="[data-ca-bulkedit-default-object=true]"
                        data-ca-bulkedit-enable="[data-ca-bulkedit-expanded-object=true]"
                    />
                </th>
                <th>
                </th>
                <th><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("name")}{if $search.sort_by === "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
                <th width="6%" class="mobile-hide">&nbsp;</th>
                <th width="10%" class="right"><a class="cm-ajax" href="{"`$c_url`&sort_by=status&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("status")}{if $search.sort_by === "status"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            </tr>
            </thead>
            {foreach from=$departaments item=departament}
            <tr class="cm-row-status-{$departament.status|lower} cm-longtap-target"
                {if $has_permission}
                    data-ca-longtap-action="setCheckBox"
                    data-ca-longtap-target="input.cm-item"
                    data-ca-id="{$departament.departament_id}"
                {/if}
            >   {capture name="buttons"}
                {$allow_save=true}
                {include file="common/view_tools.tpl" url="dev_departaments.update?product_id="}
                {/capture}
                {if $allow_save}
                    {$no_hide_input="cm-no-hide-input"}
                {else}
                    {$no_hide_input=""}
                {/if}
                <td>
                <img srcset="{$departament.main_pair.icon.image_path}" src="{$departament.main_pair.icon.image_path}" width="50" height="66" alt="" class="products-list__image--img" title="">
                </td>
                <td width="6%" class="left mobile-hide">
                    <input type="checkbox" name="departament_ids[]" value="{$departament.departament_id}" class="cm-item {$no_hide_input} cm-item-status-{$departament.status|lower} hide" /></td>
                <td class="{$no_hide_input}" data-th="{__("name")}">
                    <a class="row-status" href="{"dev_departaments.update_departament?departament_id=`$departament.departament_id`"|fn_url}">{$departament.departament}</a>
                </td>
                <td width="6%" class="mobile-hide">
                    {capture name="tools_list"}
                        <li>{btn type="list" text=__("edit") href="dev_departaments.update_departament?departament_id=`$departament.departament_id`"}</li>
                    {if $allow_save}
                        <li>{btn type="list" class="cm-confirm" text=__("delete") href="dev_departaments.delete_departament?departament_id=`$departament.departament_id`" method="POST"}</li>
                    {/if}
                    {/capture}
                    <div class="hidden-tools">
                        {dropdown content=$smarty.capture.tools_list}
                    </div>
                </td>
                <td width="10%" class="right" data-th="{__("status")}">
                    {include file="common/select_popup.tpl" id=$departament.departament_id status=$departament.status hidden=false object_id_name="departament_id" table="dev_departaments" popup_additional_class="`$no_hide_input` dropleft"}
                </td>
            </tr>
            {/foreach}
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="dev_departaments_form"
        object="dev_departaments"
        items=$smarty.capture.dev_departaments_table
        has_permissions=$has_permission
    }
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_contents_dev_departaments"}

{capture name="adv_buttons"}     
    {include file="common/tools.tpl" tool_href="dev_departaments.add_departament" prefix="top" hide_tools="true" title="Добавить отдел" icon="icon-plus"}
{/capture}
</form>
{/capture}
{capture name="sidebar"}
    {hook name="dev_departaments:manage_sidebar"}
    {include file="common/saved_search.tpl" dispatch="dev_departaments.manage" view_type="dev_departaments"}
    {/hook}
{/capture}

{hook name="dev_departaments:manage_mainbox_params"}
    {$page_title = __("dev_departaments")}
    {$select_languages = true}
{/hook}

{include file="common/mainbox.tpl" title=$page_title content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons select_languages=$select_languages sidebar=$smarty.capture.sidebar}

