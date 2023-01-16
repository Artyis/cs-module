{if $departament_data}
    {assign var="id" value=$departament_data.departament_id}
{else}
    {assign var="id" value=0}
{/if}


{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit" name="dev_departaments_form" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
<input type="hidden" class="cm-no-hide-input" name="departament_id" value="{$id}" />
    <div id="content_general">
        <div class="control-group">
            <label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
            <div class="controls">
            <input type="text" name="departament_data[departament]" id="elm_banner_name" value="{$departament_data.departament}" size="25" class="input-large" /></div>
            
        </div>
    </div>
    
        <div class="control-group" id="banner_graphic">
            <label class="control-label">{__("image")}</label>
            <div class="controls">
                {include 
                    file="common/attach_images.tpl"
                    image_name="departament"
                    image_object_type="departament"
                    image_pair=$departament_data.main_pair
                    image_object_id=$id
                    no_detailed=true
                    hide_titles=true
                }
            </div>
        </div>

        <div class="control-group" id="banner_text">
            <label class="control-label cm-required" for="elm_banner_description">{__("description")}:</label>
            <div class="controls">
                <textarea id="elm_banner_description" name="departament_data[description]" cols="35" rows="8" class="cm-wysiwyg input-large">{$departament_data.description}</textarea>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
            {if $departament_data}
            <div class="cm-hide-inputs">
            {else}
            <div class="controls">
            {/if}
            {include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="departament_data[timestamp]" date_val=$departament_data.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
            </div>
        </div>
            <div class="control-group">
                <label class="control-label cm-required">{__("leader")}</label>
                <div class="controls">
                    {include file="pickers/users/picker.tpl" 
                    but_text=__("add_leader") 
                    data_id="return_users" 
                    but_meta="btn" 
                    input_name="departament_data[lead_user_id]" 
                    item_ids=$departament_data.lead_user_id 
                    placement="right"
                    display="radio"
                    view_mode="single_button"
                    user_info=$u_info
                    }
                </div>
            </div>
            <div class="control-group">
                <label class="control-label cm-required">{__("workers")}</label>
                <div class="controls">
                    {include file="pickers/users/picker.tpl" 
                    but_text=__("add_worker") 
                    data_id="return_users" 
                    but_meta="btn" 
                    input_name="departament_data[workers_ids]" 
                    item_ids=$departament_data.worker_ids 
                    placement="left"
                    view_mode="mixed"
                    user_info=$u_info
                    }
                </div>
            </div>
            {include file="common/select_status.tpl" input_name="departament_data[status]" id="elm_banner_status" obj_id=$id obj=$departament_data hidden=false}    
    </div>
{capture name="buttons"}
    {if !$id}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="dev_departaments_form" but_name="dispatch[dev_departaments.update_departament]"}
    {else}
        {capture name="tools_list"}
        <li>{btn type="list" text=__("delete") class="cm-confirm" href="dev_departaments.delete_departament?departament_id=`$id`" method="POST"}</li>
        {/capture}
        {dropdown content=$smarty.capture.tools_list}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[dev_departaments.update_departament]" but_role="submit-link" but_target_form="dev_departaments_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
    {/if}
{/capture}

</form>

{/capture}

{include file="common/mainbox.tpl"
    title=($id) ? $departament_data.departament : __("add_departament")
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons
    select_languages=true}

