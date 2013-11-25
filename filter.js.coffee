# Works with Normal json record hash
root = exports ? this
root.filterRecords = (record_json) ->
  generatedFilters = generateFilterParameters()
  matched_filters = generatedFilters[0]
  text_filters = generatedFilters[1]
  filtered_json = []
  is_filtered_record =
  $.each record_json, (index, record) ->
    filtered = true
    select = true
    $.each matched_filters, (filter_name, filter_values_array) ->
      attr_value = eval("record." + filter_name)
      if attr_value instanceof Array
        filtered = isSomethingCommon(attr_value, filter_values_array)
      else if filter_values_array.indexOf(attr_value) == -1
        filtered = false
    unless $.isEmptyObject text_filters
      select = false
      $.each text_filters, (filter_name, filter_values_array) ->
        select = false
        attr_value = eval("record." + filter_name)
        $.each filter_values_array, (index, search_text) ->
          if (attr_value.toLowerCase()).indexOf(search_text) != -1
            select = true
    if filtered and select
      filtered_json.push(record)
  filtered_json

generateFilterParameters = ->
  exact_match_filters = {}
  text_match_filters = {}
  filter_values = []
  remove_filters = []
  $("[filter_name]").each (i, e) ->
    if e.tagName is 'SELECT'
      exact_match_filters[$(this).attr('filter_name')] = [typecast($(this).val(), $(this).attr("filter_type"))] if $(this).val() != ""
    else if e.tagName is 'INPUT' and ($(this).attr("type") is "checkbox" or $(this).attr("type") is "radio") and $(this).is(":checked")
      if exact_match_filters[$(this).attr('filter_name')] is undefined
        exact_match_filters[$(this).attr('filter_name')] = [typecast($(this).val(), $(this).attr("filter_type"))]
      else
        (exact_match_filters[$(this).attr('filter_name')]).push(typecast($(this).val(), $(this).attr("filter_type")))
    else if e.tagName is 'INPUT' and $(this).attr("type") is "text" and $.trim($(this).val()) isnt ""
      if text_match_filters[$(this).attr('filter_name')] is undefined
        text_match_filters[$(this).attr('filter_name')] = [$.trim($(this).val().toLowerCase())]
      else
        text_match_filters[$(this).attr('filter_name')].push($.trim($(this).val().toLowerCase()))
  $.each exact_match_filters, (key, val) ->
    remove_filters.push key  if (val.indexOf("all") isnt -1) or (val.indexOf("All") isnt -1)
  $.each remove_filters, (index, val) ->
    delete exact_match_filters[val]
  [exact_match_filters, text_match_filters]

typecast = (val, cast_type) ->
  if cast_type is "int"
    parseInt(val)
  else if cast_type is 'boolean'
    (if val is "true" then true else false)
  else
    val

isSomethingCommon = (records_array, filter_array) ->
  matches = false
  $.each filter_array, (index, val) ->
    if records_array.indexOf(val) != -1
      matches = true
  matches


# Backbbone records json hash
root = exports ? this
root.filterRecords = (record_json) ->
  generatedFilters = generateFilterParameters()
  matched_filters = generatedFilters[0]
  text_filters = generatedFilters[1]
  filtered_json = []
  is_filtered_record =
  $.each record_json, (index, record) ->
    filtered = true
    select = true
    $.each matched_filters, (filter_name, filter_values_array) ->
      attr_value = eval("record.get('" + filter_name + "')")
      if attr_value instanceof Array
        filtered = isSomethingCommon(attr_value, filter_values_array)
      else if filter_values_array.indexOf(attr_value) == -1
        filtered = false
    unless $.isEmptyObject text_filters
      select = false
      $.each text_filters, (filter_name, filter_values_array) ->
        select = false
        attr_value = eval("record.get('" + filter_name + "')")
        $.each filter_values_array, (index, search_text) ->
          if (attr_value.toLowerCase()).indexOf(search_text) != -1
            select = true
    if filtered and select
      filtered_json.push(record)
  filtered_json

generateFilterParameters = ->
  exact_match_filters = {}
  text_match_filters = {}
  filter_values = []
  remove_filters = []
  $("[filter_name]").each (i, e) ->
    if e.tagName is 'SELECT'
      exact_match_filters[$(this).attr('filter_name')] = [typecast($(this).val(), $(this).attr("filter_type"))] if $(this).val() != ""
    else if e.tagName is 'INPUT' and ($(this).attr("type") is "checkbox" or $(this).attr("type") is "radio") and $(this).is(":checked")
      if exact_match_filters[$(this).attr('filter_name')] is undefined
        exact_match_filters[$(this).attr('filter_name')] = [typecast($(this).val(), $(this).attr("filter_type"))]
      else
        (exact_match_filters[$(this).attr('filter_name')]).push(typecast($(this).val(), $(this).attr("filter_type")))
    else if e.tagName is 'INPUT' and $(this).attr("type") is "text" and $.trim($(this).val()) isnt ""
      if text_match_filters[$(this).attr('filter_name')] is undefined
        text_match_filters[$(this).attr('filter_name')] = [$.trim($(this).val().toLowerCase())]
      else
        text_match_filters[$(this).attr('filter_name')].push($.trim($(this).val().toLowerCase()))
  $.each exact_match_filters, (key, val) ->
    remove_filters.push key  if (val.indexOf("all") isnt -1) or (val.indexOf("All") isnt -1)
  $.each remove_filters, (index, val) ->
    delete exact_match_filters[val]
  [exact_match_filters, text_match_filters]

typecast = (val, cast_type) ->
  if cast_type is "int"
    parseInt(val)
  else if cast_type is 'boolean'
    (if val is "true" then true else false)
  else
    val

isSomethingCommon = (records_array, filter_array) ->
  matches = false
  $.each filter_array, (index, val) ->
    if records_array.indexOf(val) != -1
      matches = true
  matches