
{if $departaments}

    {script src="js/tygh/exceptions.js"}
 
    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}

    {if !$show_empty}
        {split data=$departaments size=$columns|default:"2" assign="splitted_departaments"}
    {else}
        {split data=$departaments size=$columns|default:"2" assign="splitted_departaments" skip_complete=true}
    {/if}

    <div class="grid-list">
        {strip} 
                {foreach from=$departaments item="departament" name="sdepartaments"}
                    <div class="ty-column{$columns}">
                        {if $departament}
                            {assign var="obj_id" value=$departament.departament_id}
                            {assign var="obj_id_prefix" value="`$obj_prefix``$departament.departament_id`"}
                            
                           
                                        <div class="ty-grid-list__image">
                                            <a href="{"departaments.departament?departament_id={$departament.departament_id}"|fn_url}">
                                            {include file="common/image.tpl" 
                                            no_ids=true images=$departament.main_pair 
                                            image_width=$settings.Thumbnails.product_lists_thumbnail_width 
                                            image_height=$settings.Thumbnails.product_lists_thumbnail_height 
                                            lazy_load=true}
                                            </a>
                                        </div>
            
                                        <div class="ty-grid-list__item-name">
                                        {if $departament.user_info.firstname && $departament.user_info.lastname}
                                            {__("leader")} {$departament.user_info.firstname} {$departament.user_info.lastname} 
                                        {/if}
                                            {__("leader")} {$departament.user_info.firstname}        
                                        </div>
                                        <div class="ty-grid-list__item-name">
                                        <bdi>
                                        <a href="{"dev_departaments.departament?departament_id={$departament.departament_id}"|fn_url}" class="product-title" title="{$departament.departament}">{$departament.departament}</a>    
                                        </bdi>
                                        </div>
                            
                        {/if}
                    </div>
            {/foreach}
        {/strip}
    </div>
    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}
{/if}
{capture name="mainbox_title"}{$title}{/capture}