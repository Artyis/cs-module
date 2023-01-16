<div id="departament_features_{$departament.departament_id}">
<div class="ty-feature">

    {if $departament_data.main_pair}
    <div class="ty-feature__image">
        {include file="common/image.tpl" images=$departament_data.main_pair}
    </div>
    {/if}
    <div class="ty-feature__description ty-wysiwyg-content">
        <b>{__("description")}:</b> 
        <br>
        {if $departament_data.description}
        {$departament_data.description}
        {/if}
        <br>
        <b>{__("leader")}:</b> 
        <br>
        {$departament_data.user_info.firstname} {$departament_data.user_info.lastname}
        <br>
        <b>{__("workers")}:</b>                      
        {foreach from=$departament_data.workers item="worker"}
            <br> 
            {$worker.firstname} {$worker.lastname}
        {/foreach}
    </div>
</div>
</div>

{capture name="mainbox_title"}{$collection_data.variant nofilter}{/capture}