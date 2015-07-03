GridForms =
  el:
    fieldsRows:       document.querySelectorAll '[data-row-span]'
    fieldsContainers: document.querySelectorAll '[data-field-span]'
    focusableFields:  document.querySelectorAll '[data-field-span] input, [data-field-span] textarea, [data-field-span] select'

  init: () ->
    focusedFields = [].filter.call this.el.focusableFields, (element) ->
      return element == document.activeElement

    this.focusField(focusedFields)
    this.equalizeFieldHeights()
    this.events()

  focusField: (currentField) ->
    found = false

    while currentField && !found
      parent = currentField.parentElement

      if parent && parent.matches '[data-field-span]'
        found = true
        currentField = parent

      currentField = parent

    if currentField
      currentField.classList.add 'focus'

  removeFieldFocus: () ->
    for field in this.el.fieldsContainers
      field.classList.remove 'focus'

  events: () ->
    that = this

    for fieldsContainer in that.el.fieldsContainers
      fieldsContainer.addEventListener 'click', (event) ->
        fields = event.currentTarget.querySelector('input, textarea, select')
        if fields
          fields.focus()

    for focusableField in that.el.focusableFields
      focusableField.addEventListener 'focus', (event) ->
        that.focusField(event.currentTarget)

      focusableField.addEventListener 'blur', (event) ->
        that.removeFieldFocus()

    window.addEventListener 'resize', () ->
      that.equalizeFieldHeights()

  equalizeFieldHeights: () ->
    for container in this.el.fieldsContainers
      container.style.height = 'auto'

    fieldsRows = this.el.fieldsRows
    fieldsContainers = this.el.fieldsContainers

    if !this.areFieldsStacked()
      for fieldRow in fieldsRows
        rowHeight = fieldRow.clientHeight

        for container in fieldRow.querySelectorAll '[data-field-span]'
          container.style.height = rowHeight + 'px'

  areFieldsStacked: () ->
    firstRow = [].filter.call this.el.fieldsRows, (element) ->
      return !element.matches '[data-row-span="1"]'

    totalWidth = 0

    if firstRow.length
      firstRow = firstRow[0]

    if firstRow.children
      for children in firstRow.children
        totalWidth += children.clientWidth

      return firstRow.clientWidth <= totalWidth

GridForms.init()
window.GridForms = GridForms
